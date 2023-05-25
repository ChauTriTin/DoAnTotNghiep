import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static const KEY_GG = "KEY_GG";

  static Future<void> setInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static Future<void> setBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

// static Future<void> setGG(GG gg) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setString(KEY_GG, jsonEncode(gg));
// }
//
// static Future<GG?> getGG() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? jsonString = prefs.getString(KEY_GG);
//   if (jsonString == null) {
//     return null;
//   }
//   try {
//     return GG.fromJson(jsonDecode(jsonString));
//   } catch (e) {
//     return null;
//   }
// }
}
