import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/api_url.dart';
import 'random_ads_event.dart';
import 'random_ads_state.dart';

class RandomAdsBloc extends Bloc<RandomAdsEvent, RandomAdsState> {
  RandomAdsBloc() : super(RandomAdsInitial()) {
    on<FetchRandomAds>(_onFetchRandomAds);
  }

  Future<void> _onFetchRandomAds(
      FetchRandomAds event, Emitter<RandomAdsState> emit) async {
    emit(RandomAdsLoading());

    final connectivity = await Connectivity().checkConnectivity();

    try {
      final response =
          await http.get(Uri.parse('$API_URL/get/ads.php?q=getAds&user=1'));

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> ads =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));

        emit(RandomAdsLoaded(ads));
      } else {
        emit(RandomAdsError("Failed to load ads"));
      }
    } catch (e) {
      emit(RandomAdsError("Something went wrong"));
    }
  }
}
