import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake/flutter_snake.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  late final WebViewController _controller;
  bool isError = false;
  bool isSuccess = false;
  int count = 0;

  StreamController<GAME_EVENT>? controllerS;
  SnakeGame? snakeGame;
  bool isGameOver = false;
  bool isFirstOpen = true;
  @override
  void initState() {
    super.initState();
    prefs.then((SharedPreferences prefs) {
      bool isFirstOpen_ = prefs.getBool('isFirstOpen') ?? true;
      if (isFirstOpen_) {
        prefs.setBool('isFirstOpen', false);
      } else {
        setState(() {
          isFirstOpen = false;
        });
      }
    });
    controllerS = StreamController<GAME_EVENT>();
    controllerS?.stream.listen((GAME_EVENT value) {
      if (value == GAME_EVENT.out_of_map) {
        setState(() {
          isGameOver = true;
        });
      }
      print(value.toString());
    });
    snakeGame = SnakeGame(
      caseWidth: 25.0,
      numberCaseHorizontally: 11,
      numberCaseVertically: 11,
      controllerEvent: controllerS,
      durationBetweenTicks: Duration(milliseconds: 400),
      colorBackground1: Color(0XFF7CFC00),
      colorBackground2: Color(0XFF32CD32),
    );
    hasNetwork().then((val) {
      if (!val) {
        if (!isError) {
          setState(() {
            isError = true;
          });
        }
      }
    });

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url suc: $isSuccess');
            isSuccess = true;
          },
          onPageFinished: (String url) {
            if (isError && isSuccess) {
              setState(() {
                isError = false;
              });
            }
            debugPrint('Page finished loading: $url suc $isSuccess');
          },
          onWebResourceError: (WebResourceError error) {
            isSuccess = false;
            setState(() {
              isError = true;
            });
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            if (request.url.startsWith('tel:')) {
              debugPrint('blocking navigation to ${request.url}');
              launchUrl(Uri(
                scheme: 'tel',
                path: request.url.replaceAll('tel:', ''),
              ));
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
          onHttpAuthRequest: (HttpAuthRequest request) {},
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse('https://kyrgyz.space/p/autopark/app/'));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);

      (controller.platform as AndroidWebViewController)
          .setOnShowFileSelector(_androidFilePicker);
    }
    // #enddocregion platform_features

    _controller = controller;
  }

  @override
  void dispose() {
    controllerS?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        _controller.platform.currentUrl().then((value) async {
          late bool canGoBack;
          if (value!.endsWith('/app') || value.endsWith('/app/')) {
            canGoBack = false;
          } else {
            if (await _controller.canGoBack()) {
              canGoBack = true;
            } else {
              canGoBack = false;
            }
          }
          if (canGoBack) {
            _controller.goBack();
          } else {}
        });
        //we need to return a future
      },
      child: isFirstOpen
          ? Container(
              alignment: Alignment.topLeft,
              decoration: const BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: AssetImage("assets/img/bg.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 90,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 25),
                    padding: EdgeInsets.all(30),
                    width: 250,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.42),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50))),
                    child: Text(
                      'Не теряйте время - начните свою покупку или продажу уже сегодня!',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.all(30),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isFirstOpen = false;
                        });
                      },
                      child: Text(
                        'Продолжить',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 90,
                  ),
                ],
              ),
            )
          : Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
                backgroundColor: Colors.black,
              ),
              body: !isError
                  ? WebViewWidget(controller: _controller)
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          count > 0
                              ? Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      isGameOver
                                          ? Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 30),
                                              child: Text(
                                                'Вы проиграли. Поиграйте еще раз',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 18),
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  onPressed: () =>
                                                      snakeGame?.nextDirection =
                                                          SNAKE_MOVE.left,
                                                  icon: Icon(
                                                    Icons
                                                        .subdirectory_arrow_left,
                                                    size: 40,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 80,
                                                ),
                                                IconButton(
                                                  onPressed: () =>
                                                      snakeGame?.nextDirection =
                                                          SNAKE_MOVE.right,
                                                  icon: Icon(
                                                    Icons
                                                        .subdirectory_arrow_right,
                                                    size: 40,
                                                  ),
                                                ),
                                              ],
                                            ),
                                      snakeGame ?? Text("Not initialized"),
                                    ],
                                  ),
                                )
                              : Container(
                                  padding: EdgeInsets.only(bottom: 50),
                                  child: Text(
                                    'Auto Park',
                                    style: TextStyle(
                                        fontSize: 40, color: Colors.black),
                                  ),
                                ),
                          count > 0
                              ? Container(
                                  height: 50,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Вы пробовали ',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          '$count',
                                          style: TextStyle(fontSize: 40),
                                        ),
                                        Text(
                                          ' раз(а)',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ]),
                                )
                              : SizedBox(
                                  height: 1,
                                ),
                          SizedBox(
                            height: 80,
                          ),
                          Text(
                              'Не удалось загрузить страницу. \nПроверьте подключение к сети!'),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              _controller.loadRequest(Uri.parse(
                                  'https://kyrgyz.space/p/autopark/app/'));
                              setState(() {
                                count = ++count;
                                isGameOver = false;
                              });
                            },
                            child: Text('Повторить попытку'),
                          ),
                        ],
                      ),
                    ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Future<List<String>> _androidFilePicker(FileSelectorParams params) async {
  FilePickerResult? result = await FilePicker.platform
      .pickFiles(allowMultiple: true, type: FileType.image);

  if (result != null) {
    List<File> files = result.paths.map((path) => File(path!)).toList();
    return files.map((file) => file.uri.toString()).toList(growable: false);
  } else {
    return [];
  }
}

Future<bool> hasNetwork() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}
