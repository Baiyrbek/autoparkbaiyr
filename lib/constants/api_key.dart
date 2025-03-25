import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_url.dart';

String API_KEY = "1"; // Default value

Future<void> initializeApiKey() async {
  try {
    // Try to get API_KEY from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final savedApiKey = prefs.getString('api_key');

    if (savedApiKey != null) {
      API_KEY = savedApiKey;
      return;
    }

    // Check network connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return; // Keep default API_KEY if no network
    }

    // Try to get API_KEY from network
    final response = await http.get(
      Uri.parse('$API_URL/get/user.php?q=getUserId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null) {
        final newApiKey = data;
        // Save to SharedPreferences
        await prefs.setString('api_key', newApiKey);
        API_KEY = newApiKey;
      }
    }
  } catch (e) {
    print('Error initializing API_KEY: $e');
    // Keep default API_KEY on error
  }
}
