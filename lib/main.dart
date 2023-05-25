import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    GetMaterialApp(
      enableLog: true,
      debugShowCheckedModeBanner: true,
      defaultTransition: Transition.cupertino,
      home: const MyApp(),
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
    return const MyHomePage(title: StringConstants.appName);
  }
}
