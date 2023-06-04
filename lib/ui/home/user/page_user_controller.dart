import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../model/place.dart';
import '../../../model/user.dart';
import '../../../util/shared_preferences_util.dart';

class PageUserController extends BaseController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  var tripParticipatedCount = 0.obs;
  var leadTripCount = 0.obs;
  var totalKm = 0.obs;

  var userData = UserData(
    "",
    "",
    "",
    "",
  ).obs;

  var places = <Place>[
    Place(),
    Place(),
    Place(),
    Place(),
    Place(),
    Place(),
    Place(),
    Place(),
    Place(),
  ].obs;

  void clearOnDispose() {
    Get.delete<PageUserController>();
  }

  void signOut() {
    setAppLoading(true, "Loading", TypeApp.logout);
    SharedPreferencesUtil.setUID("");
    auth.signOut();
    setAppLoading(false, "Loading", TypeApp.logout);
  }

  Future<void> getData() async {
    getUserInfo();
    getTotalTripCount();
    getTrip();
    getTotalTripCount();
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

  String getAvatar() {
    String avatarUrl = userData.value.avatar;
    if (avatarUrl.isEmpty) {
      return StringConstants.avatarImgDefault;
    } else {
      return avatarUrl;
    }
  }

  String getName() {
    return userData.value.name;
  }

  Future<void> getTrip() async {
    // List<Place> fakePlace = fakePlace();
    // places.value = fakePlace;
  }

  Future<void> getTotalKm() async {
    // List<Place> fakePlace = fakePlace();
    // places.value = fakePlace;
  }

  Future<void> getTotalTripCount() async {
    // List<Place> fakePlace = fakePlace();
    // places.value = fakePlace;
  }
}
