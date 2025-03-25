import 'package:dodoshautopark/constants/lang_strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'publish_event.dart';
import 'publish_state.dart';
import 'dart:io';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class PublishBloc extends Bloc<PublishEvent, PublishState> {
  
  Timer? _errorTimer;

  void _loadBrands() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final brands = prefs.getStringList('brands') ?? state.brands;
      emit(state.copyWith(brands: brands));
    } catch (e) {
      // If there's an error reading the list (like wrong type),
      // keep using the default brands from state
      print('Error loading brands: $e');
    }
  }

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

    // Load brands when bloc is created
    _loadBrands();
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
            '${STRINGS[LANG]?['year_required'] ?? 'Please select year'}',
            emit);
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
    emit(state.copyWith(selectedBrand: event.brand));
  }

  void _onUpdateModel(UpdateModelEvent event, Emitter<PublishState> emit) {
    emit(state.copyWith(selectedModel: event.model));
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

      // TODO: Implement API call to submit the ad
      await Future.delayed(Duration(seconds: 2)); // Simulate API call

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
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

  @override
  Future<void> close() {
    _errorTimer?.cancel();
    return super.close();
  }
}
