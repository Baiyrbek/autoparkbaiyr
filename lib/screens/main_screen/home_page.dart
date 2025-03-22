import 'package:dodoshautopark/constants/lang_strings.dart';
import 'package:dodoshautopark/screens/main_screen/home_page/brands_widget.dart';
import 'package:dodoshautopark/screens/main_screen/home_page/random_ads_bottom_sheet.dart';
import 'package:dodoshautopark/screens/main_screen/home_page/story_widget.dart';
import 'package:dodoshautopark/screens/main_screen/home_page/top_bar.dart';
import 'package:flutter/material.dart';

import '../search_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Middle Scrollable Section
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(top: 68.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StoriesWidget(),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text(
                      STRINGS[LANG]!["brands"]!,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  BrandsWidget(),
                ],
              ),
            ),
          ),

          //bottomSheet

         RandomAdsBottomSheet(),

          // Top Bar
          TopBar(onSearchPressed: () {
            Navigator.of(context).push(_reateRoute());
          })
        ],
      ),
    );
  }
}

Route _reateRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SearchScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1.0, 0.0); // Slide from left
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
