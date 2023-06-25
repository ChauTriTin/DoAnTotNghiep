import 'dart:convert';

import 'package:appdiphuot/model/push_notification.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static const KEY_GG = "KEY_GG";
  static const USER_UID = "USER_UID";
  static const IS_DARK_MODE_ON = "IS_DARK_MODE_ON";
  static const USER_IFO = "USER_IFO";
  static const KEY_FCM_TOKEN = "KEY_FCM_TOKEN";
  static const KEY_LIST_NOTI = "KEY_LIST_NOTI";

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

  static Future<void> addNotification(
      String key, PushNotification notification) async {
    debugPrint('addNotification');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var list = getListNotification(key);
    list.then((value) {
      debugPrint('~~~addNotification list ${jsonEncode(value)}');

      var listTmp = <PushNotification>[];
      for (var element in value) {
        listTmp.add(element);
      }

      if (listTmp.isEmpty) {
        listTmp.add(notification);
      } else {
        listTmp.insert(0, notification);
      }

      debugPrint('addNotification ~~~ listTmp length ${listTmp.length}');
      for (var element in listTmp) {
        debugPrint(
            'addNotification element ${element.title} - ${element.body}');
      }

      String rawJson = jsonEncode(listTmp);
      debugPrint('addNotification rawJson $rawJson');

      prefs.setString(key, rawJson);
      debugPrint('addNotification done ${jsonEncode(listTmp)}');
    });
  }

  static Future<List<PushNotification>> getListNotification(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final rawJson = prefs.getString(key) ?? '';
      debugPrint('getListNotification rawJson $rawJson');

      List<PushNotification> list = List<PushNotification>.from(
          jsonDecode(rawJson).map((x) => PushNotification.fromJson(x)));

      debugPrint('getListNotification list ${list.length}');
      return list;
    } catch (e) {
      debugPrint('getListNotification e ${e.toString()}');
      return List.empty();
    }
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
