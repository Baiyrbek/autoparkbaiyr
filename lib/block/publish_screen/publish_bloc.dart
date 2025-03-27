import 'dart:convert';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dodoshautopark/constants/api_key.dart';
import 'package:dodoshautopark/constants/lang_strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Emitter;
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import '../../constants/api_url.dart';
import '../../constants/constaint_def.dart';
import '../../utils_bl/models.dart';
import '../../utils_bl/publish.dart';
import 'publish_event.dart';
import 'publish_state.dart';
import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:amplify_flutter/amplify_flutter.dart' as amplify;
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;

class PublishBloc extends Bloc<PublishEvent, PublishState> {
  Timer? _errorTimer;

  PublishBloc() : super(PublishState()) {
    on<NextPageEvent>(_onNextPage);
    on<PreviousPageEvent>(_onPreviousPage);
    on<UpdateImagesEvent>(_onUpdateImages);
    on<UpdateBrandEvent>(_onUpdateBrand);
    on<UpdateModelEvent>(_onUpdateModel);
    on<UpdateYearEvent>(_onUpdateYear);
    on<UpdateRegionEvent>(_onUpdateRegion);
    on<UpdatePriceEvent>(_onUpdatePrice);
    on<UpdateDescriptionEvent>(_onUpdateDescription);
    on<SubmitPublishEvent>(_onSubmitPublish);
    on<ClearErrorEvent>(_onClearError);
    on<GetBrandsEvent>(_onGetBrands);
    on<GetAllModelsEvent>(_onGetAllModels);
    on<UpdateModelsEvent>(_onUpdateModels);
  }

  void _setErrorWithTimer(String error, Emitter<PublishState> emit) {
    _errorTimer?.cancel();
    emit(state.copyWith(error: error));
    _errorTimer = Timer(Duration(seconds: 2), () {
      add(ClearErrorEvent());
    });
  }

  void _onNextPage(NextPageEvent event, Emitter<PublishState> emit) {
    if (state.currentPage == 0 && state.selectedImages.isEmpty) {
      _setErrorWithTimer(
          '${STRINGS[LANG]?['choose_photo_error'] ?? 'Please select at least 1 photo'}',
          emit);
      return;
    }

    if (state.currentPage == 1) {
      if (state.selectedBrand == null || state.selectedModel == null) {
        _setErrorWithTimer(
            '${STRINGS[LANG]?['brand_model_required'] ?? 'Please select brand and model'}',
            emit);
        return;
      }
      if (state.selectedYear == null) {
        _setErrorWithTimer(
            '${STRINGS[LANG]?['year_required'] ?? 'Please select year'}', emit);
        return;
      }
      if (state.price == null || state.price!.isEmpty) {
        _setErrorWithTimer(
            '${STRINGS[LANG]?['price_required'] ?? 'Please enter price'}',
            emit);
        return;
      }
    }

    if (state.currentPage == 2 && state.selectedRegion == null) {
      _setErrorWithTimer(
          '${STRINGS[LANG]?['region_required'] ?? 'Please select a region'}',
          emit);
      return;
    }

    if (state.currentPage < 3) {
      emit(state.copyWith(currentPage: state.currentPage + 1, error: null));
    }
  }

  void _onPreviousPage(PreviousPageEvent event, Emitter<PublishState> emit) {
    if (state.currentPage > 0) {
      emit(state.copyWith(currentPage: state.currentPage - 1, error: null));
    }
  }

  void _onUpdateImages(UpdateImagesEvent event, Emitter<PublishState> emit) {
    final List<File> files = event.images.map((path) => File(path)).toList();
    emit(state.copyWith(selectedImages: files));
  }

  void _onUpdateBrand(UpdateBrandEvent event, Emitter<PublishState> emit) {
    emit(state.copyWith(
      selectedBrand: event.brand,
      selectedModel: null, // Reset selected model when brand changes
    ));
    add(UpdateModelsEvent());
  }

  void _onUpdateModel(UpdateModelEvent event, Emitter<PublishState> emit) {
    emit(state.copyWith(selectedModel: event.model));
  }

  void _onUpdateModels(UpdateModelsEvent event, Emitter<PublishState> emit) {
    if (state.selectedBrand == null) {
      emit(state.copyWith(models: [], selectedModel: null));
      return;
    }

    try {
      final brandId = state.brands
          .firstWhere((brand) => brand['name'] == state.selectedBrand)['id'];

      final filteredModels = state.allModels
          .where((model) => model['parent'] == brandId)
          .map((model) => model['name'] as String)
          .toList();

      // If current selected model is not in filtered list, reset it
      if (state.selectedModel != null &&
          !filteredModels.contains(state.selectedModel)) {
        emit(state.copyWith(
          models: filteredModels,
          selectedModel: null,
        ));
      } else {
        emit(state.copyWith(models: filteredModels));
      }
    } catch (e) {
      print('Error updating models: $e');
      emit(state.copyWith(models: [], selectedModel: null));
    }
  }

  void _onUpdateYear(UpdateYearEvent event, Emitter<PublishState> emit) {
    emit(state.copyWith(selectedYear: event.year));
  }

  void _onUpdateRegion(UpdateRegionEvent event, Emitter<PublishState> emit) {
    emit(state.copyWith(
        selectedRegion: event.region.isEmpty ? null : event.region));
  }

  void _onUpdatePrice(UpdatePriceEvent event, Emitter<PublishState> emit) {
    emit(state.copyWith(price: event.price));
  }

  void _onUpdateDescription(
      UpdateDescriptionEvent event, Emitter<PublishState> emit) {
    emit(state.copyWith(description: event.description));
  }

  Future<void> _onSubmitPublish(
      SubmitPublishEvent event, Emitter<PublishState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    List<String> uploadedUrls = [];

    try {
      // Validate required fields
      if (state.selectedImages.isEmpty) {
        throw Exception('Please add at least one photo');
      }
      if (state.selectedBrand == null || state.selectedModel == null) {
        throw Exception('Please select brand and model');
      }
      if (state.selectedYear == null) {
        throw Exception('Please select year');
      }
      if (state.selectedRegion == null) {
        throw Exception('Please select region');
      }
      if (state.price == null || state.price!.isEmpty) {
        throw Exception('Please enter price');
      }

      // Upload images to S3
      final List<String> uploadedNames = [];
      int i = 0;
      for (File imageFile in state.selectedImages) {
        try {
          i++;

          String imageName =
              '${API_KEY}_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
          if (i == 1) {
            File file = imageFile;
            Uint8List imageBytes = await file.readAsBytes();
            img.Image originalImage = img.decodeImage(imageBytes)!;

            // Resize to max 620 (height or width)
            img.Image resized620 = img.copyResize(originalImage,
                width: originalImage.width > originalImage.height ? 620 : null,
                height: originalImage.height > originalImage.width ? 620 : null,
                interpolation: img.Interpolation.linear);

            File resizedFile620 = File('${file.parent.path}/resized_620.jpg')
              ..writeAsBytesSync(img.encodeJpg(resized620, quality: 80));

            final s3Key = 'ads_img_preview/$imageName';

            final uploadResult = await amplify.Amplify.Storage
                .uploadFile(
                  key: s3Key,
                  localFile: amplify.AWSFile.fromPath(resizedFile620.path),
                )
                .result;

            final urlResult = await amplify.Amplify.Storage
                .getUrl(
                  key: s3Key,
                )
                .result;
          }
          final s3Key = 'ads_img/$imageName';

          final uploadResult = await amplify.Amplify.Storage
              .uploadFile(
                key: s3Key,
                localFile: amplify.AWSFile.fromPath(imageFile.path),
              )
              .result;

          final urlResult = await amplify.Amplify.Storage
              .getUrl(
                key: s3Key,
              )
              .result;
          print('Uploaded image name: $imageName');
          uploadedNames.add(imageName);
        } catch (e) {
          print('Upload error for image: $e');
          throw Exception('Failed to upload images');
        }
      }

      // TODO: Send uploadedUrls along with other data to your backend
      print('Uploaded image names: $uploadedNames');
      String brand = state.brands
          .firstWhere((brand) => brand['name'] == state.selectedBrand)['id'];
      String model = state.allModels.firstWhere((model) =>
          model['name'] == state.selectedModel &&
          model['parent'] == brand)['id'];
      String year = state.selectedYear!;
      String price = state.price!;
      String region = GlobalVars.region
          .indexWhere((region) => region == state.selectedRegion)
          .toString();
      String description = state.description ?? '';
      bool published = await publishAd(
          brand, model, year, price, region, description, uploadedNames);
      if (published) {
        emit(state.copyWith(
          isLoading: false,
          showSuccessModal: true,
          showErrorModal: false,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          showSuccessModal: false,
          showErrorModal: true,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        showErrorModal: true,
        error: e.toString(),
      ));
    }
  }

  void _onClearError(ClearErrorEvent event, Emitter<PublishState> emit) {
    emit(state.copyWith(error: null));
  }

  Future<List<String>> pickImages() async {
    try {
      final picker = image_picker.ImagePicker();
      final List<image_picker.XFile> images = await picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (images.isEmpty) return [];

      final List<String> newImages = [];
      for (var image in images) {
        if (newImages.length + state.selectedImages.length >= 8) break;
        newImages.add(image.path);
      }

      return newImages;
    } catch (e) {
      add(ClearErrorEvent());
      return [];
    }
  }

  void _onGetBrands(GetBrandsEvent event, Emitter<PublishState> emit) async {
    try {
      List<Map<String, dynamic>> brands = [];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('brands');
      if (cachedData != null) {
        // Parse the saved JSON string and return the image URLs
        final List<dynamic> data = json.decode(cachedData);
        brands = data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        brands = [];
      }
      emit(state.copyWith(brands: brands));
    } catch (e) {
      print('Error loading brands: $e');
    }
  }

  void _onGetAllModels(
      GetAllModelsEvent event, Emitter<PublishState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Try to get from SharedPreferences first
      final String? modelsJson = prefs.getString('all_models');
      List<Map<String, dynamic>> models;

      if (modelsJson != null) {
        // Parse the JSON string to List<Map>
        final List<dynamic> decoded = json.decode(modelsJson);
        models = decoded.cast<Map<String, dynamic>>();
      } else {
        // If not in SharedPreferences, fetch from network
        models = await fetchModelsFromNetwork();

        // Save to SharedPreferences for next time
        if (models.isNotEmpty) {
          await prefs.setString('all_models', json.encode(models));
        }
      }

      emit(state.copyWith(allModels: models));
    } catch (e) {
      print('Error loading models: $e');
    }
  }

  @override
  Future<void> close() {
    _errorTimer?.cancel();
    return super.close();
  }
}
