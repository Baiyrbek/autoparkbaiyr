import 'package:flutter_bloc/flutter_bloc.dart';

import 'brands_event.dart';
import 'brands_repo.dart';
import 'brands_state.dart';

class BrandsBloc extends Bloc<BrandsEvent, BrandsState> {
  final BrandsRepository repository;

  BrandsBloc(this.repository) : super(BrandsInitial()) {
    on<LoadBrands>((event, emit) async {
      emit(BrandsLoading());
      try {
        final brands = await repository.getBrands();
        emit(BrandsLoaded(brands));
      } catch (e) {
        emit(BrandsError("Failed to load images"));
      }
    });
    on<GetLoadedBrands>((event, emit) async {
      emit(BrandsLoading());
      try {
        final brands = await repository.getBrands(cashed: true);
        emit(BrandsLoaded(brands));
      } catch (e) {
        emit(BrandsError("Failed to load cached brands"));
      }
    });
  }
}
