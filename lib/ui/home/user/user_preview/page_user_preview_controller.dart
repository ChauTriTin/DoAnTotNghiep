import 'dart:developer';
import 'dart:io';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:get/get.dart';
import 'package:google_maps_directions/google_maps_directions.dart';

import '../../../../common/const/string_constants.dart';
import '../../../../db/firebase_helper.dart';
import '../../../../model/place.dart';
import '../../../../model/trip.dart';
import '../../../../model/user.dart';
import '../../../../util/distance_util.dart';
import '../../../../util/log_dog_utils.dart';
import '../../../../util/shared_preferences_util.dart';
import '../../../user_singleton_controller.dart';

class PageUserPreviewController extends BaseController {
  final Rx<File?> _selectedImage = Rx<File?>(null);

  File? get selectedImage => _selectedImage.value;

  var tripParticipatedCount = 0.obs;
  var totalKm = 0.0.obs;

  var userData = UserData().obs;
  var userId = "".obs;

  var trips = <Trip>[].obs;
  var tripsHost = <Trip>[].obs;
  var tripsInProgress = <Trip>[].obs;

  void clearOnDispose() {
    Get.delete<PageUserPreviewController>();
  }

  Future<void> getData() async {
    getUserDetail();
    getTrip();
    getTripHost();
    getTripInProgress();
    getTripIsCompleted();
  }

  Future<void> getUserDetail() async {
    Dog.d("getUserDetail: $userId");
    FirebaseHelper.collectionReferenceUser
        .doc(userId.value)
        .snapshots()
        .listen((value) {
      DocumentSnapshot<Map<String, dynamic>>? userMap = value as DocumentSnapshot<Map<String, dynamic>>?;
      log("getUserDetail value: $value -- $userMap");
      if (userMap == null || userMap.data() == null) return;

      var user = UserData.fromJson((userMap).data()!);
      userData.value = user;
      log("getUserDetail success: ${user.toString()}");
    });
  }

  Future<void> getTrip() async {
    try {
      String uid = userId.value;
      log("getTrip: userid $uid");
      var routerStream = FirebaseHelper.collectionReferenceRouter
          .where(FirebaseHelper.listIdMember, arrayContainsAny: [uid])
          .snapshots();

      var routerSnapshots =
          routerStream.map((querySnapshot) => querySnapshot.docs);

      routerSnapshots.listen((routerSnapshots) {
        var tempTrips = <Trip>[];

        for (var routerSnapshot in routerSnapshots) {
          log("getTrip: $routerSnapshot");

          DocumentSnapshot<Map<String, dynamic>>? tripMap =
              routerSnapshot as DocumentSnapshot<Map<String, dynamic>>?;

          if (tripMap == null || tripMap.data() == null) return;

          var trip = Trip.fromJson((tripMap).data()!);
          tempTrips.add(trip);
        }

        trips.value = tempTrips;
      });
    } catch (e) {
      log("getTrip: $e");
    }
  }

  Future<void> getTripHost() async {
    try {
      String uid = userId.value;
      log("getTripHost: userid $uid");
      var routerStream = FirebaseHelper.collectionReferenceRouter
          .where(FirebaseHelper.userIdHost, isEqualTo: uid)
          .snapshots();

      var routerSnapshots =
          routerStream.map((querySnapshot) => querySnapshot.docs);

      routerSnapshots.listen((routerSnapshots) {
        var tempTrips = <Trip>[];

        for (var routerSnapshot in routerSnapshots) {
          log("getTripHost: $routerSnapshot");

          DocumentSnapshot<Map<String, dynamic>>? tripMap =
              routerSnapshot as DocumentSnapshot<Map<String, dynamic>>?;

          if (tripMap == null || tripMap.data() == null) return;

          var trip = Trip.fromJson((tripMap).data()!);
          tempTrips.add(trip);
        }

        tripsHost.value = tempTrips;
      });
    } catch (e) {
      log("getTripHost: $e");
    }
  }

  String getUserGender() {
    switch (userData.value.gender) {
      case 0: return StringConstants.male;
      case 1: return StringConstants.female;
      default: return StringConstants.other;
    }
  }

  Future<void> getTripInProgress() async {
    try {
      String uid = await SharedPreferencesUtil.getUIDLogin() ?? "";
      log("getTripInProgress: userid $uid");
      var routerStream = FirebaseHelper.collectionReferenceRouter
          .where(FirebaseHelper.listIdMember, arrayContainsAny: [uid])
          .where(FirebaseHelper.isComplete, isEqualTo: false)
          .snapshots();

      var routerSnapshots =
      routerStream.map((querySnapshot) => querySnapshot.docs);

      routerSnapshots.listen((routerSnapshots) {
        var tempTrips = <Trip>[];

        for (var routerSnapshot in routerSnapshots) {
          log("getTripInProgress: $routerSnapshot");

          DocumentSnapshot<Map<String, dynamic>>? tripMap =
          routerSnapshot as DocumentSnapshot<Map<String, dynamic>>?;

          if (tripMap == null || tripMap.data() == null) return;

          var trip = Trip.fromJson((tripMap).data()!);
          tempTrips.add(trip);
        }

        tripsInProgress.value = tempTrips;
      });
    } catch (e) {
      log("getTripInProgress: $e");
    }
  }

  Future<void> getTripIsCompleted() async {
    try {
      String uid = await SharedPreferencesUtil.getUIDLogin() ?? "";
      log("getTrip: userid $uid");
      var routerStream = FirebaseHelper.collectionReferenceRouter
          .where(FirebaseHelper.listIdMember, arrayContainsAny: [uid])
          .where(FirebaseHelper.isComplete, isEqualTo: true)
          .snapshots();

      var routerSnapshots =
      routerStream.map((querySnapshot) => querySnapshot.docs);

      routerSnapshots.listen((routerSnapshots) async {
        var tempTrips = <Trip>[];

        for (var routerSnapshot in routerSnapshots) {
          log("getTrip: $routerSnapshot");

          DocumentSnapshot<Map<String, dynamic>>? tripMap =
          routerSnapshot as DocumentSnapshot<Map<String, dynamic>>?;

          if (tripMap == null || tripMap.data() == null) return;

          var trip = Trip.fromJson((tripMap).data()!);
          tempTrips.add(trip);
        }

        trips.value = tempTrips;

        totalKm.value = await DistanceUtil.getTotalKm(tempTrips);
      });
    } catch (e) {
      log("getTrip: $e");
    }
  }
}
