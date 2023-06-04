import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/model/place.dart';
import 'package:appdiphuot/model/trip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../common/const/string_constants.dart';
import '../../../../model/user.dart';
import '../../../../util/shared_preferences_util.dart';

class TripDetailController extends BaseController {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  var place = Place().obs;
  var userData = UserData(
    "",
    "",
    "",
    "",
  ).obs;

  var tripParticipatedCount = 0.obs;
  var leadTripCount = 0.obs;
  var totalKm = 0.obs;

  var tripData = Trip().obs;

  void setTripData(Trip data) {
    tripData.value = data;
  }

  void clearOnDispose() {
    Get.delete<TripDetailController>();
  }

  Future<void> getData() async {
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    try {
      String uid = await SharedPreferencesUtil.getUIDLogin() ?? "";
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

  String getName() {
    return userData.value.name;
  }

  String getAvatar() {
    String avatarUrl = userData.value.avatar;
    if (avatarUrl.isEmpty) {
      return StringConstants.avatarImgDefault;
    } else {
      return avatarUrl;
    }
  }
}
