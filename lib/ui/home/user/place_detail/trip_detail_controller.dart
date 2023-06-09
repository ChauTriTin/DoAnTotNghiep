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
  var userData = UserData().obs;
  var usersParticipated = <UserData>[].obs;
  var userHostTrip = UserData().obs;
  var tripParticipatedCount = 0.obs;
  var totalKm = 0.obs;
  var tripData = Trip().obs;

  void setTripData(Trip data) {
    tripData.value = data;
  }

  void clearOnDispose() {
    Get.delete<TripDetailController>();
  }

  Future<void> getData() async {
    var currentUid = await SharedPreferencesUtil.getUIDLogin() ?? "";
    _getUserInfo(currentUid);
    _getUserHostTrip(tripData.value.userIdHost ?? "");
    _getUserParticipated(currentUid);
  }

  Future<void> _getUserInfo(String uid) async {
    try {
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

  Future<void> _getUserHostTrip(String uid) async {
    try {
      _users.doc(uid).snapshots().listen((value) {
        DocumentSnapshot<Map<String, dynamic>>? userMap =
            value as DocumentSnapshot<Map<String, dynamic>>?;
        if (userMap == null || userMap.data() == null) return;

        var user = UserData.fromJson((userMap).data()!);
        userHostTrip.value = user;
        log("getUserHostTrip success: ${user.toString()}");
      });
    } catch (e) {
      log("getUserHostTrip get user info fail: $e");
    }
  }

  String getName() {
    return userData.value.name ?? "";
  }

  String getAvatar() {
    String avatarUrl = userData.value.avatar ?? "";
    if (avatarUrl.isEmpty) {
      return StringConstants.avatarImgDefault;
    } else {
      return avatarUrl;
    }
  }

  Future<void> _getUserParticipated(String currentUid) async {
    try {
      if (tripData.value.listIdMember == null ||
          tripData.value.listIdMember?.isEmpty == true) return;
      var tempUserList = <UserData>[];
      for (var uid in tripData.value.listIdMember!) {
        DocumentSnapshot userSnapshot = await _users.doc(uid).get();
        if (!userSnapshot.exists) {
          continue;
        }

        DocumentSnapshot<Map<String, dynamic>>? userMap =
            userSnapshot as DocumentSnapshot<Map<String, dynamic>>?;
        if (userMap == null || userMap.data() == null) return;

        var user = UserData.fromJson((userMap).data()!);
        tempUserList.add(user);
        log("_getUserParticipated success: ${user.toString()}");
      }
      usersParticipated.value = tempUserList;
    } catch (e) {
      log("_getUserParticipated get user info fail: $e");
    }
  }
}
