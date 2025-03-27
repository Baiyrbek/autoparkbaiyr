import 'package:equatable/equatable.dart';

abstract class PublishEvent extends Equatable {
  const PublishEvent();

  @override
  List<Object?> get props => [];
}

class GetBrandsEvent extends PublishEvent {}

class GetAllModelsEvent extends PublishEvent {}

class UpdateModelsEvent extends PublishEvent {}

class NextPageEvent extends PublishEvent {}

class PreviousPageEvent extends PublishEvent {}

class UpdateImagesEvent extends PublishEvent {
  final List<String> images;

  const UpdateImagesEvent(this.images);

  @override
  List<Object?> get props => [images];
}

class UpdateBrandEvent extends PublishEvent {
  final String brand;

  const UpdateBrandEvent(this.brand);

  @override
  List<Object?> get props => [brand];
}

class UpdateModelEvent extends PublishEvent {
  final String model;

  const UpdateModelEvent(this.model);

  @override
  List<Object?> get props => [model];
}

class UpdateYearEvent extends PublishEvent {
  final String year;

  const UpdateYearEvent(this.year);

  @override
  List<Object?> get props => [year];
}

class UpdateRegionEvent extends PublishEvent {
  final String region;

  const UpdateRegionEvent(this.region);

  @override
  List<Object?> get props => [region];
}

class UpdatePriceEvent extends PublishEvent {
  final String price;

  const UpdatePriceEvent(this.price);

  @override
  List<Object?> get props => [price];
}

class UpdateDescriptionEvent extends PublishEvent {
  final String description;

  const UpdateDescriptionEvent(this.description);

  @override
  List<Object?> get props => [description];
}

class SubmitPublishEvent extends PublishEvent {}

class ClearErrorEvent extends PublishEvent {}

class NavigateToMainScreenEvent extends PublishEvent {} 