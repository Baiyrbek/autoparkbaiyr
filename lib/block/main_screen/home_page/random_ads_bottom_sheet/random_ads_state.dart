

abstract class RandomAdsState  {
  @override
  List<Object?> get props => [];
}

class RandomAdsInitial extends RandomAdsState {}

class RandomAdsLoading extends RandomAdsState {}

class RandomAdsLoaded extends RandomAdsState {
  final List<Map<String, dynamic>> ads;
  RandomAdsLoaded(this.ads);

  @override
  List<Object?> get props => [ads];
}

class RandomAdsError extends RandomAdsState {
  final String message;
  RandomAdsError(this.message);

  @override
  List<Object?> get props => [message];
}
