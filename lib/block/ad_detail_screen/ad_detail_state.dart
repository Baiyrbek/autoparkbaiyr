import 'package:equatable/equatable.dart';

class AdDetailState extends Equatable {
  final Map<String, dynamic>? adInfo;
  final bool isInFavorite;
  final bool isLoading;
  final bool hasError;
  final String errorMessage;
  final List<String> images;
  final int currentImageIndex;

  const AdDetailState({
    this.adInfo,
    this.isInFavorite = false,
    this.isLoading = true,
    this.hasError = false,
    this.errorMessage = '',
    this.images = const [],
    this.currentImageIndex = 0,
  });

  AdDetailState copyWith({
    Map<String, dynamic>? adInfo,
    bool? isInFavorite,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    List<String>? images,
    int? currentImageIndex,
  }) {
    return AdDetailState(
      adInfo: adInfo ?? this.adInfo,
      isInFavorite: isInFavorite ?? this.isInFavorite,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      images: images ?? this.images,
      currentImageIndex: currentImageIndex ?? this.currentImageIndex,
    );
  }

  @override
  List<Object?> get props => [
        adInfo,
        isInFavorite,
        isLoading,
        hasError,
        errorMessage,
        images,
        currentImageIndex,
      ];
} 