import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_fcm/flutter_fcm.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:overlay_support/overlay_support.dart';

import 'model/push_notification.dart';
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
  Messaging.initFCM();

  runApp(
    OverlaySupport.global(
      child: GetMaterialApp(
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

class Messaging {
  static String? token;

  static deleteToken() {
    Messaging.token = null;
    FCM.deleteRefreshToken();
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationReceived(RemoteMessage message) async {
    await Firebase.initializeApp();
    debugPrint('FCM main Handling a message ${message.messageId}');
    PushNotification notification = PushNotification(
      title: message.notification?.title,
      body: message.notification?.body,
      dataTitle: message.data['title'],
      dataBody: message.data['body'],
    );
    debugPrint('FCM main Handling a notification ${notification.toString()}');
    //TODO loitp
  }

  @pragma('vm:entry-point')
  static initFCM() async {
    try {
      await Firebase.initializeApp();
      await FCM.initializeFCM(
        withLocalNotification: true,
        onNotificationReceived: onNotificationReceived,
        onNotificationPressed: (Map<String, dynamic> data) {},
        onTokenChanged: (String? token) {
          if (token != null) {
            debugPrint('FCM main token  $token.');
            Messaging.token = token;
          }
        },
        icon: 'ic_launcher',
      );
    } catch (e) {
      debugPrint('FCM main e $e');
    }
  }
}
