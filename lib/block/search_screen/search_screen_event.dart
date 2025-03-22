abstract class SearchEvent {}

class PerformSearch extends SearchEvent {
  final String query;
  PerformSearch(this.query);
}

class SelectButton extends SearchEvent {
  final int index;
  SelectButton(this.index);
}

class SetSelectedBrandId extends SearchEvent {
  final String brandId;
  SetSelectedBrandId(this.brandId);
}