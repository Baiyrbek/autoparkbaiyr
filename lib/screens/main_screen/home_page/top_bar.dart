import 'package:dodoshautopark/utils/autopark_logo_svg.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final VoidCallback onSearchPressed;

  const TopBar({Key? key, required this.onSearchPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        width: double.infinity,
        padding:
            EdgeInsetsDirectional.symmetric(horizontal: 18.0, vertical: 14.0),
        color: const Color(0xC0000000),
        alignment: Alignment.center,
        child: Row(
          children: [
            // Search Icon Button
            Material(
              color: Colors
                  .transparent, // Ensures the background color is transparent
              child: InkWell(
                onTap: onSearchPressed,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Icon(Icons.search, color: Colors.white, size: 22),
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
      ),
    );
  }
}
