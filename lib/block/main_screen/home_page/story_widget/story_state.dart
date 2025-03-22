
abstract class StoryState  {
  @override
  List<Object> get props => [];
}

class StoryInitial extends StoryState {}

class StoryLoading extends StoryState {}

class StoryLoaded extends StoryState {
  final List<String> images;
  StoryLoaded(this.images);
  
  @override
  List<Object> get props => [images];
}

class StoryError extends StoryState {
  final String message;
  StoryError(this.message);
  
  @override
  List<Object> get props => [message];
}
