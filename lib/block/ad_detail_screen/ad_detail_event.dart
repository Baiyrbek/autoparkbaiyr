import 'package:equatable/equatable.dart';

abstract class AdDetailEvent extends Equatable {
  const AdDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadAdDetailEvent extends AdDetailEvent {
  final String adId;

  const LoadAdDetailEvent(this.adId);

  @override
  List<Object?> get props => [adId];
}

class ToggleFavoriteEvent extends AdDetailEvent {}

class UpdateImageIndexEvent extends AdDetailEvent {
  final int index;

  const UpdateImageIndexEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class RetryLoadEvent extends AdDetailEvent {
  final String adId;

  const RetryLoadEvent(this.adId);

  @override
  List<Object?> get props => [adId];
} 