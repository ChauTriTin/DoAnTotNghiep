import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/util/shared_preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../model/user.dart';

class HomeController extends BaseController {
  final CollectionReference _users =
  FirebaseFirestore.instance.collection('users');

  var userData = UserData("", "", "", "", "").obs;

  String getName() {
    return userData.value.name;
  }

  String getAvatar() {
    String avatarUrl = userData.value.avatar;
    if (avatarUrl.isEmpty) {
      return "https://www.w3schools.com/howto/img_avatar.png";
    } else {
      return avatarUrl;
    }
  }

  Future<void> getUserInfo() async {
    try {
      String uid = await SharedPreferencesUtil.getUIDLogin() ?? "";
      DocumentSnapshot<Map<String, dynamic>>? userMap = (await _users
          .doc(uid)
          .get()) as DocumentSnapshot<Map<String, dynamic>>?;

      if (userMap == null || userMap.data() == null) return;

      var user = UserData.fromJson(userMap.data()!);
      userData.value = user;
      log("getUserInfo success: ${user.toString()}");
    } catch (e) {
      log("getUserInfo get user info fail: $e");
    }
  }

  void clearOnDispose() {
    Get.delete<HomeController>();
  }
}
