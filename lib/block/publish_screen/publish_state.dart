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
  final List<String> brands;
  final List<String> models;
  final List<String> years;

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
    List<String>? brands,
    List<String>? models,
    List<String>? years,
  }) : brands = brands ?? ['Brand 1', 'Brand 2', 'Brand 3'],
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
    List<String>? brands,
    List<String>? models,
    List<String>? years,
  }) {
    return PublishState(
      currentPage: currentPage ?? this.currentPage,
      selectedImages: selectedImages ?? this.selectedImages,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      selectedModel: selectedModel ?? this.selectedModel,
      selectedYear: selectedYear ?? this.selectedYear,
      selectedRegion: selectedRegion ?? this.selectedRegion,
      price: price ?? this.price,
      description: description ?? this.description,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedCity: selectedCity ?? this.selectedCity,
      brands: brands ?? this.brands,
      models: models ?? this.models,
      years: years ?? this.years,
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
        models,
        years,
      ];

  static Future<PublishState> initial() async {
    final prefs = await SharedPreferences.getInstance();
    final brands = prefs.getStringList('brands') ?? ['Brand 1', 'Brand 2', 'Brand 3'];
    print(brands);
    return PublishState(
      brands: brands,
    );
  }
} 