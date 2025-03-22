class SearchState {
  final int selectedIndex;
  final String message; // Holds the message for search results
  final String selectedBrandId; // Holds the selected brand ID (default: "0")

  SearchState({required this.selectedIndex, this.message = '', this.selectedBrandId = "0"});

  SearchState copyWith({int? selectedIndex, String? message, String? selectedBrandId}) {
    return SearchState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      message: message ?? this.message,
      selectedBrandId: selectedBrandId ?? this.selectedBrandId,
    );
  }
}

// Initial state when the search has not started
class SearchInitial extends SearchState {
  SearchInitial({required int selectedIndex}) : super(selectedIndex: selectedIndex, selectedBrandId: "0");
}

// State when search is in progress
class SearchLoading extends SearchState {
  SearchLoading(int selectedIndex) : super(selectedIndex: selectedIndex);
}

// State when search results are available
class SearchResults extends SearchState {
  SearchResults(int selectedIndex, String message) : super(selectedIndex: selectedIndex, message: message);
}

// State for when the toggle button is in the initial position (center)
class ToggleInitial extends SearchState {
  ToggleInitial() : super(selectedIndex: 1, selectedBrandId: "0"); // Default selection is center, brand ID = "0"
}

// State for when a toggle button has been selected
class ToggleSelected extends SearchState {
  ToggleSelected(int selectedIndex) : super(selectedIndex: selectedIndex);
}

// **New State: SelectedBrandId**
class SelectedBrandId extends SearchState {
  SelectedBrandId(String selectedBrandId) : super(selectedIndex: 1, selectedBrandId: selectedBrandId);
}
