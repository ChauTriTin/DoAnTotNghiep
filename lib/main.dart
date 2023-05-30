import 'dart:io';

import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/user/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import 'ui/splash/page_splash_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  if (Platform.isAndroid) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
  }
  runApp(
    GetMaterialApp(
      enableLog: true,
      debugShowCheckedModeBanner: true,
      defaultTransition: Transition.cupertino,
      home: const MyApp(),
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
