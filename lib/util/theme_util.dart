import 'package:appdiphuot/util/shared_preferences_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ThemeModeType { light, dark }

class ThemeModeNotifier {
  static ThemeModeNotifier? _instance;

  static ThemeModeNotifier get instance {
    _instance ??= ThemeModeNotifier._();
    return _instance!;
  }

  ThemeModeNotifier._();

  final _themeMode = ThemeModeType.light.obs;
  ThemeModeType get themeMode => _themeMode.value;

  Future<void> getDarkModeStatus() async {
    var isDarkModeOn = await SharedPreferencesUtil.getBool(
            SharedPreferencesUtil.IS_DARK_MODE_ON) ??
        false;
    _themeMode.value = isDarkModeOn ? ThemeModeType.dark : ThemeModeType.light;
  }

  void toggleTheme(bool isDarkMode) {
    _themeMode.value = isDarkMode ? ThemeModeType.dark : ThemeModeType.light;
  }

  ThemeData get themeData {
    return _themeMode.value == ThemeModeType.light
        ? ThemeData.light()
        : ThemeData.dark();
  }
}
