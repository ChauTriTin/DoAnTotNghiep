import 'dart:io';

import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/user/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import 'ui/splash/page_splash_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  if (Platform.isAndroid) {
    AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  }
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
  }

  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyAWieQBegz81e5gIui9LQNHN7lNVJZpiDI",
      appId: "1:529618153862:android:f0b7c1c484524d950d7c07",
      messagingSenderId: "529618153862",
      projectId: "doan-d1d53",
    ));
  } on Exception catch (_) {
    debugPrint('initializeApp fail');
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
