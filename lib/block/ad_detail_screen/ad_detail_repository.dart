import 'dart:io';
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
      //print('Fetching ad details for ID: $adId');
      final dynamic adDetails = await getAdDetailsFromNetwork(adId);
      //print('Received ad details: $adDetails');

      if (adDetails == null || adDetails.isEmpty) {
        //print('Ad details are empty or null');
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
      //print('Price currency index: $priceCurIndex');

      // Handle images
      List<String> images = [];
      try {
        final imgValue = json.decode(adDetails['img']);
        print('Raw image value: $imgValue');

        if (imgValue != null) {
          images = List<String>.from(imgValue)
              .where((img) => img != null && img.toString().isNotEmpty)
              .map((img) => '${IMG_URL['ads_img']}$img')
              .toList();
          print('Processed images: $images');
        }
      } catch (e) {
        print('Error processing images: $e');
        images = [];
      }

      final result = {
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
      //print('Final processed result: $result');
      return result;
    } catch (e, stackTrace) {
      //print('Error in getAdDetails: $e');
      //print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAdDetailsFromNetwork(String adId) async {
    try {
      //print('Making API request to: $API_URL/get/ads.php?q=getAd&id=$adId');
      final response = await http.get(
        Uri.parse('$API_URL/get/ads.php?q=getAd&id=$adId'),
      );
      //print('Response status code: ${response.statusCode}');
      //print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null) {
          return data;
        }
      }
      throw Exception('Failed to load ad details');
    } on SocketException catch (e) {
      //print('SocketException: $e');
      throw Exception(
          'No internet connection. Please check your network and try again.');
    } on HttpException catch (e) {
      //print('HttpException: $e');
      throw Exception('Could not reach the server. Please try again later.');
    } catch (e) {
      //print('General error: $e');
      throw Exception('An error occurred. Please try again.');
    }
  }

  Future<void> toggleFavorite(String adId, bool isFavorite) async {
    // TODO: Implement favorite toggle API call
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
