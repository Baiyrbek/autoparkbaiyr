import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import '../../constants/api_url.dart';
import '../../constants/constaint_def.dart';

class AdDetailRepository {
  final Connectivity _connectivity;

  AdDetailRepository({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  Future<bool> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<Map<String, dynamic>> getAdDetails(String adId) async {
    try {
      final dynamic adDetails = await getAdDetailsFromNetwork(adId);
      if (adDetails == null || adDetails.isEmpty) {
        return {
          'title': 'Unknown',
          'price': '0',
          'description': 'No details available',
          'location': 'Unknown',
          'phone': '+996550822249',
          'date': DateTime.now().toString().split(' ')[0],
          'images': [],
        };
      }

      // Convert price_cur to int if it's a string
      final priceCurIndex = adDetails['price_cur'] is String
          ? int.tryParse(adDetails['price_cur']) ?? 0
          : (adDetails['price_cur'] as int?) ?? 0;

      // Handle images
      List<String> images = [];
      final imgValue = json.decode(adDetails['img']);
      if (imgValue != null) {
        if (imgValue is List) {
          images = List<String>.from(imgValue)
              .where((img) => img != null && img.toString().isNotEmpty)
              .map((img) => '$API_URL/img/$img')
              .toList();
        }
      }
      print(images);
      return {
        'title':
            '${adDetails['brand'] ?? ''} ${adDetails['model'] ?? ''} ${adDetails['year'] ?? ''}',
        'price':
            '${adDetails['price'] ?? '0'} ${GlobalVars.priceCur[priceCurIndex]}',
        'description': adDetails['about'] ?? 'No description available',
        'location': GlobalVars.region[int.tryParse(adDetails['region']) ?? 0] ??
            'Unknown',
        'phone': '+996${adDetails['phone'] ?? '550822249'}',
        'date': adDetails['time'] ?? DateTime.now().toString().split(' ')[0],
        'images': images.isNotEmpty
            ? images
            : [
                'https://example.com/image1.jpg',
                'https://example.com/image2.jpg',
                'https://example.com/image3.jpg',
              ],
      };
    } catch (e) {
      print('Error in getAdDetails: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAdDetailsFromNetwork(String id) async {
    // Check for network connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    Map<String, dynamic> adDetails = {};

    if (connectivityResult != ConnectivityResult.none) {
      try {
        final response =
            await http.get(Uri.parse('$API_URL/get/ads.php?q=getAd&id=$id'));
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final dynamic data = json.decode(response.body);
          if (data is List && data.isNotEmpty) {
            adDetails = Map<String, dynamic>.from(data[0]);
          } else if (data is Map) {
            adDetails = Map<String, dynamic>.from(data);
          }
          print('Parsed ad details: $adDetails');
        } else {
          throw Exception('Failed to load ad details: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching ad details: $e');
        rethrow;
      }
    } else {
      throw Exception('No internet connection');
    }
    return adDetails;
  }

  Future<void> toggleFavorite(String adId, bool isFavorite) async {
    // TODO: Implement favorite toggle API call
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
