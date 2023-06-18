import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';

class SharedPreferencesUtil {
  static const KEY_GG = "KEY_GG";
  static const USER_UID = "USER_UID";
  static const IS_DARK_MODE_ON = "IS_DARK_MODE_ON";
  static const USER_IFO = "USER_IFO";
  static const KEY_FCM_TOKEN = "KEY_FCM_TOKEN";

  static Future<void> setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

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

  static Future<String?> getUIDLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_UID);
  }

  static Future<void> setUID(String userUID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(USER_UID, userUID);
  }

}
