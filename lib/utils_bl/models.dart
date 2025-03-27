 import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

import '../constants/api_url.dart';

Future<List<Map<String, dynamic>>> fetchModelsFromNetwork() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      List<Map<String, dynamic>> all_models = [];

      if (connectivityResult != ConnectivityResult.none) {
        // There is network connection, fetch images from the network
        try {
          final response = await http
              .get(Uri.parse('$API_URL/get/brands.php?q=getAllModels'));
          if (response.statusCode == 200) {
            // Parse the JSON response to extract image URLs
            final List<dynamic> data = json.decode(response.body);
            all_models = data.map((e) => e as Map<String, dynamic>).toList();
          }
        } catch (e) {
          print('Error fetching all_models: $e');
        }
      }
      return all_models;
    } catch (e) {
      print('Error fetching models from network: $e');
      return [];
    }
  }