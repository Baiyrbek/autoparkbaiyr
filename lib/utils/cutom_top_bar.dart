import 'package:flutter/material.dart';

import 'autopark_logo_svg.dart';

Widget CustomTopBar(void Function() ? onTap) {
  return Container(
    width: double.infinity,
    padding: EdgeInsetsDirectional.symmetric(horizontal: 18.0, vertical: 14.0),
    color: const Color(0xC0000000),
    alignment: Alignment.center,
    child: Row(
      children: [
        // Search Icon Button
        Material(
          color:
              Colors.transparent, // Ensures the background color is transparent
          child: InkWell(
            onTap: onTap, 
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child:
                  Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
            ),
          ),
        ),

        // Expanded Widget
        Expanded(
            child: Container(
          child: AutoparkLogoSvg(),
        )),

        // Right 24x24 Widget (Placeholder)
        Container(
          width: 28,
          height: 28,
          color: Colors.transparent, // Change this as needed
        ),
      ],
    ),
  );
}
