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

  Future<void> getTotalKm(List<Trip> trips) async {
    // try {
    double totalKmTemp = 0;
    for (var trip in trips) {
      if (trip.listPlace == null || trip.listPlace?.isEmpty == true) {
        double km = await _genDistance(trip.placeStart, trip.placeEnd);
        totalKmTemp = totalKmTemp + km;
        Dog.d("getTotalKm km of ${trip.title}: $km");
      } else {
        Place? startPlace = trip.placeStart;
        trip.listPlace?.forEach((place) async {
          double km = await _genDistance(startPlace, place);
          totalKmTemp = totalKmTemp + km;

          startPlace = place;
        });


        double km = await _genDistance(startPlace, trip.placeEnd);
        totalKmTemp = totalKmTemp + km;
      }
    }
    Dog.d("getTotalKm km: $totalKmTemp");
    totalKm.value = totalKmTemp;
  }

  Future<double> _genDistance(Place? placeA, Place? placeB) async {
    Dog.d("_genDistance: - A: ${placeA?.lat} - ${placeA?.long},  B: ${placeB?.lat} - ${placeB?.long}");
    if (placeA == null || placeB == null) return 0;
    DistanceValue distanceBetween = await distance(
      placeA.lat ?? 0,
      placeA.long ?? 0,
      placeB.lat ?? 0,
      placeB.long ?? 0,
    );
    int meters = distanceBetween.meters;
    String textInKmOrMeters = distanceBetween.text;
    debugPrint(">>>_genDistance meters $meters, textInKmOrMeters $textInKmOrMeters");
    return meters / 1000;
  }
}
