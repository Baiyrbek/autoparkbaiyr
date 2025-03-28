import 'package:equatable/equatable.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class PublishState extends Equatable {
  final int currentPage;
  final List<File> selectedImages;
  final String? selectedBrand;
  final String? selectedModel;
  final String? selectedYear;
  final String? selectedRegion;
  final String? price;
  final String? description;
  final bool isLoading;
  final String? error;
  final String selectedCity;
  final List<Map<String, dynamic>> brands;
  final List<Map<String, dynamic>> allModels;
  final List<String> models;
  final List<String> years;
  final bool showSuccessModal;
  final bool showErrorModal;

  PublishState({
    this.currentPage = 0,
    this.selectedImages = const [],
    this.selectedBrand,
    this.selectedModel,
    this.selectedYear,
    this.selectedRegion,
    this.price,
    this.description,
    this.isLoading = false,
    this.error,
    this.selectedCity = '',
    List<Map<String, dynamic>>? brands,
    List<Map<String, dynamic>>? allModels,
    List<String>? models,
    List<String>? years,
    this.showSuccessModal = false,
    this.showErrorModal = false,
  }) : brands = brands ?? [{'name': 'Brand 1'}, {'name': 'Brand 2'}, {'name': 'Brand 3'}],
       allModels = allModels ?? [],
       models = models ?? ['Model 1', 'Model 2', 'Model 3'],
       years = years ?? List.generate(
         DateTime.now().year - 1969,
         (index) => (DateTime.now().year - index).toString(),
       );

  PublishState copyWith({
    int? currentPage,
    List<File>? selectedImages,
    String? selectedBrand,
    String? selectedModel,
    String? selectedYear,
    String? selectedRegion,
    String? price,
    String? description,
    bool? isLoading,
    String? error,
    String? selectedCity,
    List<Map<String, dynamic>>? brands,
    List<Map<String, dynamic>>? allModels,
    List<String>? models,
    List<String>? years,
    bool? showSuccessModal,
    bool? showErrorModal,
  }) {
    return PublishState(
      currentPage: currentPage ?? this.currentPage,
      selectedImages: selectedImages ?? this.selectedImages,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      selectedModel: selectedBrand != null ? null : selectedModel ?? this.selectedModel,
      selectedYear: selectedYear ?? this.selectedYear,
      selectedRegion: selectedRegion ?? this.selectedRegion,
      price: price ?? this.price,
      description: description ?? this.description,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedCity: selectedCity ?? this.selectedCity,
      brands: brands ?? this.brands,
      allModels: allModels ?? this.allModels,
      models: models ?? this.models,
      years: years ?? this.years,
      showSuccessModal: showSuccessModal ?? this.showSuccessModal,
      showErrorModal: showErrorModal ?? this.showErrorModal,
    );
  }

  @override
  List<Object?> get props => [
        currentPage,
        selectedImages,
        selectedBrand,
        selectedModel,
        selectedYear,
        selectedRegion,
        price,
        description,
        isLoading,
        error,
        selectedCity,
        brands,
        allModels,
        models,
        years,
        showSuccessModal,
        showErrorModal,
      ];

  static Future<PublishState> initial() async {
    final prefs = await SharedPreferences.getInstance();
    final brandNames = prefs.getStringList('brands') ?? ['Brand 1', 'Brand 2', 'Brand 3'];
    final brands = brandNames.map((name) => {'name': name}).toList();
    return PublishState(
      brands: brands,
    );
  }
} 