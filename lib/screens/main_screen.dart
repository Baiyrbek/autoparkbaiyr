import 'package:dodoshautopark/screens/main_screen/home_page.dart';
import 'package:dodoshautopark/screens/main_screen/catalog_page.dart';
import 'package:dodoshautopark/screens/main_screen/publish_page.dart';
import 'package:dodoshautopark/screens/main_screen/marked_page.dart';
import 'package:dodoshautopark/screens/main_screen/my_ads_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../block/counter/counter_block.dart';
import '../block/counter/counter_event.dart';
import '../block/counter/counter_state.dart';
import '../constants/lang_strings.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    HomePage(),
    CatalogPage(),
    PublishPage(),
    MarkedPage(),
    MyAdsPage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onBottomNavTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onBottomNavTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          backgroundColor: Colors.white,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: STRINGS[LANG]?['home'] ?? 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: STRINGS[LANG]?['catalog'] ?? 'Catalog',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: STRINGS[LANG]?['publish'] ?? 'Publish',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: STRINGS[LANG]?['marked'] ?? 'Marked',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: STRINGS[LANG]?['my_ads'] ?? 'My Ads',
            ),
          ],
        ),
      ),
    );
  }
}
