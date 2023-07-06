import 'dart:io';

import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/model/place.dart';
import 'package:appdiphuot/ui/user_singleton_controller.dart';
import 'package:appdiphuot/util/shared_preferences_util.dart';
import 'package:appdiphuot/util/theme_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fcm/flutter_fcm.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_directions/google_maps_directions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:overlay_support/overlay_support.dart';

import 'model/push_notification.dart';
import 'notification_controller.dart';
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


  Get.put(UserSingletonController.instance);
  Get.put(NotificationController.instance);

  Messaging.initFCM();
  getLoc();
  ThemeModeNotifier.instance.getDarkModeStatus();
  GoogleMapsDirections.init(
      googleAPIKey: "AIzaSyAyXE57uyeaXMaXRlaNa-txkcNH6SaWXcU");

  // Does not update google fon't from the internet
  // GoogleFonts.config.allowRuntimeFetching = false;

  runApp(
    OverlaySupport.global(
      child: GetMaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        enableLog: true,
        debugShowCheckedModeBanner: false,
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
    return Obx(() {
      return MaterialApp(
        title: 'Dark Mode Example',
        theme: ThemeModeNotifier.instance.themeData,
        home: const SplashScreen(),
      );
    });
  }
}

class Messaging {
  static String? token;

  static deleteToken() {
    Messaging.token = null;
    FCM.deleteRefreshToken();
  }

  static Map<String, String> convertMap(Map<String, dynamic> originalMap) {
    return originalMap.map((key, value) => MapEntry(key, value.toString()));
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationReceived(RemoteMessage message) async {
    await Firebase.initializeApp();
    debugPrint('FCM main Handling a message messageId ${message.messageId}');
    debugPrint('FCM main messageData ${message.data}');

    var data = convertMap(message.data);
    PushNotification notification = PushNotification(
      title: message.notification?.title,
      body: message.notification?.body,
      dataTitle: message.data['title'],
      dataBody: message.data['body'],
      data: data,
    );

    NotificationController.instance.addNotification(notification);
    Get.dialog(
      AlertDialog(
        title: Text(notification.title ?? ""),
        content: Text(notification.body ?? ""),
        actions: [
          TextButton(
            child: const Text(StringConstants.confirm),
            onPressed: () {
              Get.back();
              SharedPreferencesUtil.addNotification(
                  SharedPreferencesUtil.KEY_LIST_NOTI, notification);
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
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
            SharedPreferencesUtil.setString(
                SharedPreferencesUtil.KEY_FCM_TOKEN, token);
            debugPrint('FCM main token  $token');
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

Future<void> getLoc() async {
  // debugPrint("getLocation~~~ ${DateTime.now().toIso8601String()}");
  LocationPermission permission = await Geolocator.requestPermission();
  // debugPrint("getLocation permission ${permission.toString()}");

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  double lat = position.latitude;
  double long = position.longitude;
  debugPrint("getLoc lat $lat");
  debugPrint("getLoc long $long");

  LatLng location = LatLng(lat, long);
  debugPrint("getLoc $location");

  defaultLat = lat;
  defaultLong = long;

  debugPrint("defaultLat $defaultLat, defaultLong $defaultLong");
}
