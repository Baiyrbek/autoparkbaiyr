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
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'amplifyconfiguration.dart';

import 'block/counter/counter_block.dart';
import 'block/main_screen/home_page/random_ads_bottom_sheet/random_ads_block.dart';
import 'block/main_screen/home_page/random_ads_bottom_sheet/random_ads_event.dart';
import 'block/main_screen/home_page/story_widget/story_block.dart';
import 'block/main_screen/home_page/story_widget/story_event.dart';
import 'block/main_screen/home_page/story_widget/story_repo.dart';
import 'block/main_screen/profile/profile_bloc.dart';
import 'block/publish_screen/publish_bloc.dart';
import 'block/search_screen/search_screen_block.dart';
import 'constants/api_key.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure Amplify
  await _configureAmplify();
  
  await initializeApiKey();
  runApp(const MyApp());
}

Future<void> _configureAmplify() async {
  try {
    // Add Auth plugin
    final auth = AmplifyAuthCognito();
    await Amplify.addPlugin(auth);

    // Add Storage plugin
    final storage = AmplifyStorageS3();
    await Amplify.addPlugin(storage);

    // Configure Amplify
    await Amplify.configure(amplifyconfig);
    print('Successfully configured Amplify');
  } catch (e) {
    print('Error configuring Amplify: $e');
  }
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
        BlocProvider(create: (context) => PublishBloc()),
        BlocProvider(create: (context) => CounterBloc()),
        BlocProvider(create: (context) => ProfileBloc()),
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
