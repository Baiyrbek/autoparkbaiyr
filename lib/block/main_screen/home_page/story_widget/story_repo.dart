import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dodoshautopark/constants/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StoryRepository {
   static const String _storyImagesKey = 'history_images';

  // Function to get images from network or SharedPreferences
  Future<List<String>> getStoryImages() async {
    // Check for network connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    List<String> imageUrls = [];

    if (connectivityResult != ConnectivityResult.none) {
      // There is network connection, fetch images from the network
      try {
        final response = await http.get(Uri.parse('$API_URL/get/stories.php?q=getStories'));
        if (response.statusCode == 200) {
          // Parse the JSON response to extract image URLs
          final List<dynamic> imagesJson = jsonDecode(response.body);
          print(imagesJson);
          imageUrls = imagesJson.map((story) => story['img'] as String).toList();

          // Save the images in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(_storyImagesKey, jsonEncode(imageUrls));
        }
      } catch (e) {
        print('Error fetching images: $e');
      }
    }

    if (imageUrls.isEmpty) {
      // No connection or empty response, fetch from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? savedImages = prefs.getString(_storyImagesKey);
      if (savedImages != null) {
        // Parse the saved JSON string and return the image URLs
        imageUrls = List<String>.from(jsonDecode(savedImages));
      }
    }

    // If still no images, return empty list
    return imageUrls;
  }
}
