import 'dart:developer';

import 'package:appdiphuot/util/shared_preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../common/const/string_constants.dart';
import '../db/firebase_helper.dart';
import '../model/user.dart';

class UserSingletonController extends GetxController {

  static UserSingletonController? _instance;

  static UserSingletonController get instance {
    _instance ??= UserSingletonController._();
    return _instance!;
  }

  UserSingletonController._();

  final userData = UserData().obs;

  Future<void> getUserInfo() async {

    try {
      String uid = await SharedPreferencesUtil.getUIDLogin() ?? "";
      log("getUserInfo-uid: $uid");
      FirebaseHelper.collectionReferenceUser
          .doc(uid)
          .snapshots()
          .listen((value) {
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

  String getName() {
    return userData.value.name ?? "";
  }
}
