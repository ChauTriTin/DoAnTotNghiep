import 'dart:developer';
import 'dart:io';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:get/get.dart';

import '../../../../db/firebase_helper.dart';
import '../../../../model/trip.dart';
import '../../../../model/user.dart';
import '../../../../util/shared_preferences_util.dart';
import '../../../user_singleton_controller.dart';

class PageUserPreviewController extends BaseController {
  final Rx<File?> _selectedImage = Rx<File?>(null);

  File? get selectedImage => _selectedImage.value;

  var tripParticipatedCount = 0.obs;
  var totalKm = 0.obs;

  var userData = UserData().obs;
  var userChat = const User(id: "").obs;

  var trips = <Trip>[].obs;
  var tripsHost = <Trip>[].obs;

  void clearOnDispose() {
    Get.delete<PageUserPreviewController>();
  }

  Future<void> getData() async {
    getUserDetail();
    getTrip();
    getTripHost();
    getTotalTripCount();
  }

  Future<void> getUserDetail() async {
    FirebaseHelper.collectionReferenceUser
        .doc(userChat.value.id)
        .snapshots()
        .listen((value) {
      DocumentSnapshot<Map<String, dynamic>>? userMap =
      value as DocumentSnapshot<Map<String, dynamic>>?;
      if (userMap == null || userMap.data() == null) return;

      var user = UserData.fromJson((userMap).data()!);
      userData.value = user;
      log("getUserInfo success: ${user.toString()}");
    });
  }

  Future<void> getTrip() async {
    try {
      String uid = userChat.value.id;
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
      String uid = userChat.value.id;
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

  Future<void> getTotalKm() async {
    // List<Place> fakePlace = fakePlace();
    // places.value = fakePlace;
  }

  Future<void> getTotalTripCount() async {
    // List<Place> fakePlace = fakePlace();
    // places.value = fakePlace;
  }

}
