import 'package:flutter_bloc/flutter_bloc.dart';

import 'search_screen_event.dart';
import 'search_screen_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  // Initialize the state with SearchInitial, passing selectedIndex.
  SearchBloc() : super(SearchInitial(selectedIndex: 0)) {
    on<PerformSearch>((event, emit) async {
      // Start by emitting SearchLoading state while preserving selectedBrandId
      emit(SearchLoading(state.selectedIndex).copyWith(selectedBrandId: state.selectedBrandId));

      await Future.delayed(Duration(seconds: 1)); // Simulate API request

      // Emit SearchResults with the message while preserving selectedBrandId
      if (event.query.isNotEmpty) {
        emit(SearchResults(state.selectedIndex, "Results for '${event.query}'")
            .copyWith(selectedBrandId: state.selectedBrandId));
      } else {
        emit(SearchResults(state.selectedIndex, "No results found.")
            .copyWith(selectedBrandId: state.selectedBrandId));
      }
    });

    on<SelectButton>((event, emit) {
      // Emit ToggleSelected with the new selected index while preserving selectedBrandId
      emit(ToggleSelected(event.index).copyWith(selectedBrandId: state.selectedBrandId));
    });

    on<SetSelectedBrandId>((event, emit) {
      // Emit SelectedBrandId with the new brand ID while preserving selectedIndex
      emit(SelectedBrandId(event.brandId).copyWith(selectedIndex: state.selectedIndex));
    });
  }
}
