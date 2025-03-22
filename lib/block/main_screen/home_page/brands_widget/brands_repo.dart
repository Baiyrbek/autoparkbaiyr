import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dodoshautopark/constants/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class BrandsRepository {
  static const String _brandsKey = 'brands';

  // Function to get images from network or SharedPreferences
  Future<List<Map<String, dynamic>>> getBrands({bool cashed = false}) async {
    List<Map<String, dynamic>> brands = [];
    if (cashed) {
      brands = await getBrandsFromMemory();

      if (brands.isEmpty) {
        brands = await getBrandsFromNetwork();
      }
    } else {
      brands = await getBrandsFromNetwork();

      if (brands.isEmpty) {
        brands = await getBrandsFromMemory();
      }
    }
    // If still no images, return empty list
    return brands;
  }

  Future<List<Map<String, dynamic>>> getBrandsFromNetwork() async {
    // Check for network connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    List<Map<String, dynamic>> brands = [];

    if (connectivityResult != ConnectivityResult.none) {
      // There is network connection, fetch images from the network
      try {
        final response =
            await http.get(Uri.parse('$API_URL/get/brands.php?q=getBrands'));
        if (response.statusCode == 200) {
          // Parse the JSON response to extract image URLs
          final List<dynamic> data = json.decode(response.body);
          brands = data.map((e) => e as Map<String, dynamic>).toList();

          // Save the images in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(_brandsKey, jsonEncode(brands));
        }
      } catch (e) {
        print('Error fetching images: $e');
      }
    }
    return brands;
  }

  // Function to get images from network or SharedPreferences
  Future<List<Map<String, dynamic>>> getBrandsFromMemory(
      {bool cashed = false}) async {
    List<Map<String, dynamic>> brands = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString(_brandsKey);
    if (cachedData != null) {
      // Parse the saved JSON string and return the image URLs
      final List<dynamic> data = json.decode(cachedData);
      brands = data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      brands = [];
    }

    // If still no images, return empty list
    return brands;
  }
}
