import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../common/const/string_constants.dart';
import '../../../../model/user.dart';

class DetailRouterController extends BaseController {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  var userData = UserData().obs;

  Future<void> getUserInfo(String uid) async {
    try {
      log("getUserInfo uid: $uid");
      if (uid == "") return;
      _users.doc(uid).snapshots().listen((value) {
        DocumentSnapshot<Map<String, dynamic>>? userMap =
            value as DocumentSnapshot<Map<String, dynamic>>?;
        if (userMap == null || userMap.data() == null) return;

        var user = UserData.fromJson((userMap).data()!);
        userData.value = user;
        log("getUserInfo success: ${user.toString()}");
      });
    } catch (e) {
      log("getUserInfo get user info fail: $e");
    }
  }

  String getAvatar() {
    String avatarUrl = userData.value.avatar ?? "";
    if (avatarUrl.isEmpty) {
      return StringConstants.avatarImgDefault;
    } else {
      return avatarUrl;
    }
  }

  String getNameLeader() {
    String name = userData.value.name ?? "";
    if (name.isEmpty) {
      return "";
    } else {
      return name;
    }
  }
}
