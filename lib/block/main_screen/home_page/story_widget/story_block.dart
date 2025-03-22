import 'package:flutter_bloc/flutter_bloc.dart';

import 'story_event.dart';
import 'story_repo.dart';
import 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final StoryRepository repository;

  StoryBloc(this.repository) : super(StoryInitial()) {
    on<LoadStories>((event, emit) async {
      emit(StoryLoading());
      try {
        final images = await repository.getStoryImages();
        emit(StoryLoaded(images));
      } catch (e) {
        emit(StoryError("Failed to load images"));
      }
    });
  }
}
