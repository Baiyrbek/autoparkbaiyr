import 'dart:async';
import 'dart:io';

import 'package:dodoshautopark/block/main_screen/home_page/brands_widget/brands_block.dart';
import 'package:dodoshautopark/block/main_screen/home_page/brands_widget/brands_event.dart';
import 'package:dodoshautopark/block/main_screen/home_page/brands_widget/brands_repo.dart';
  import 'package:dodoshautopark/screens/main_screen.dart';
  import 'package:file_picker/file_picker.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:url_launcher/url_launcher.dart';
  import 'package:webview_flutter/webview_flutter.dart';
  import 'package:webview_flutter_android/webview_flutter_android.dart';
  import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
  import 'package:flutter_snake/flutter_snake.dart';

import 'block/counter/counter_block.dart';
import 'block/main_screen/home_page/random_ads_bottom_sheet/random_ads_block.dart';
import 'block/main_screen/home_page/random_ads_bottom_sheet/random_ads_event.dart';
import 'block/main_screen/home_page/story_widget/story_block.dart';
import 'block/main_screen/home_page/story_widget/story_event.dart';
import 'block/main_screen/home_page/story_widget/story_repo.dart';
import 'block/search_screen/search_screen_block.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StoryBloc(StoryRepository())..add(LoadStories()),
        ),
        BlocProvider(
          create: (context) =>
              BrandsBloc(BrandsRepository())..add(LoadBrands()),
        ),
        BlocProvider(
            create: (context) => RandomAdsBloc()..add(FetchRandomAds())),
        BlocProvider(
            create: (context) => RandomAdsBloc()..add(FetchRandomAds())),
        BlocProvider(create: (context) => SearchBloc()),
        BlocProvider(create: (context) => CounterBloc()),
      ],
      child: MaterialApp(
        title: 'AutoPark',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        home: MainScreen(),
      ),
    );
  }
}
