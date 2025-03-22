
import 'package:flutter/material.dart';

Widget CustomTextInput(controller, onSearchPressed) {
  return Container(
    decoration: BoxDecoration(
      color: Color(0x339D9D9D), // Background color of the text input field
      borderRadius: BorderRadius.circular(15),
    ),
    child: TextField(
      controller: controller,
      style: TextStyle(color: Colors.white), // Text color is white
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            horizontal: 16, vertical: 8), // Padding for the text field
        border: InputBorder.none, // Removes the default border
        suffixIcon: Material(
          color: Colors.transparent, // Transparent background for the icon
          child: InkWell(
            onTap: () => onSearchPressed(), // Callback when the icon is tapped
            borderRadius: BorderRadius.circular(
                15), // Ensures the icon's tap area matches the field's border
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Padding for the search icon
              child: Icon(Icons.search, color: Colors.white), // Search icon
            ),
          ),
        ),
      ),
    ),
  );
}
