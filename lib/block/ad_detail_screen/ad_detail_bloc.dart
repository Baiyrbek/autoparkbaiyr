import 'package:flutter_bloc/flutter_bloc.dart';
import 'ad_detail_event.dart';
import 'ad_detail_repository.dart';
import 'ad_detail_state.dart';

class AdDetailBloc extends Bloc<AdDetailEvent, AdDetailState> {
  final AdDetailRepository _repository;
  final String adId;

  AdDetailBloc({
    required AdDetailRepository repository,
    required this.adId,
  })  : _repository = repository,
        super(const AdDetailState()) {
    on<LoadAdDetailEvent>(_onLoadAdDetail);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<UpdateImageIndexEvent>(_onUpdateImageIndex);
    on<RetryLoadEvent>(_onRetryLoad);
  }

  Future<void> _onLoadAdDetail(
    LoadAdDetailEvent event,
    Emitter<AdDetailState> emit,
  ) async {
    try {
      final hasConnection = await _repository.checkConnectivity();
      if (!hasConnection) {
        emit(state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: 'No internet connection. Please check your network settings.',
        ));
        return;
      }

      final adInfo = await _repository.getAdDetails(event.adId);
      emit(state.copyWith(
        adInfo: adInfo,
        images: List<String>.from(adInfo['images'] ?? []),
        isLoading: false,
        hasError: false,
      ));
    } catch (e) {
      print(e.toString());
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Failed to load ad ${e.toString()}',
      ));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<AdDetailState> emit,
  ) async {
    try {
      await _repository.toggleFavorite(adId, !state.isInFavorite);
      emit(state.copyWith(isInFavorite: !state.isInFavorite));
    } catch (e) {
      // Revert the favorite state if the API call fails
      emit(state.copyWith(
        hasError: true,
        errorMessage: 'Failed to update favorite status: ${e.toString()}',
      ));
    }
  }

  void _onUpdateImageIndex(
    UpdateImageIndexEvent event,
    Emitter<AdDetailState> emit,
  ) {
    emit(state.copyWith(currentImageIndex: event.index));
  }

  Future<void> _onRetryLoad(
    RetryLoadEvent event,
    Emitter<AdDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, hasError: false));
    await _onLoadAdDetail(LoadAdDetailEvent(event.adId), emit);
  }
} 