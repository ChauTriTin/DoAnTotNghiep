import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/model/notification_data.dart';
import 'package:appdiphuot/model/push_notification.dart';
import 'package:appdiphuot/util/log_dog_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../db/firebase_helper.dart';
import '../../../model/trip.dart';
import '../../../model/user.dart';
import '../../user_singleton_controller.dart';

class PageNotiController extends BaseController {
  var listNotification = <PushNotification>[].obs;
  var notificationCollection = FirebaseHelper.collectionReferenceNotification;
  final _users = FirebaseHelper.collectionReferenceUser;
  final _router = FirebaseHelper.collectionReferenceRouter;
  var currentUser = UserSingletonController.instance.userData;

  void clearOnDispose() {
    Get.delete<PageNotiController>();
  }

  void getData() {
    getNotification();
  }

  void getNotification() {
    var userID = currentUser.value.uid;
    try {
      var notificationStream = notificationCollection
          .doc(userID)
          .collection(FirebaseHelper.keyNotification)
          .snapshots();

      var notificationSnapshot =
          notificationStream.map((querySnapshot) => querySnapshot.docs);

      notificationSnapshot.listen((chatSnapshots) async {
        log("getNotification: Update message");
        var tempNotifications = <PushNotification>[];

        for (var chatSnapshot in chatSnapshots) {
          DocumentSnapshot<Map<String, dynamic>>? notification = chatSnapshot;

          if (notification.data() == null) return;

          var notiData = PushNotification.fromJson((notification).data()!);
          tempNotifications.insert(0, notiData);
        }
        listNotification.value = tempNotifications;
      });
    } catch (e) {
      Dog.e("getNotification error: ${e.toString()}");
    }
  }

  Future<UserData?> getUserData(String? userId) async {
    try {
      log("getUserInfo-uid: $userId");
      if (userId == null || userId.isEmpty) {
        return null;
      }

      DocumentSnapshot userSnapshot = await _users.doc(userId).get();
      if (!userSnapshot.exists) {
        return null;
      }

      DocumentSnapshot<Map<String, dynamic>>? userMap =
          userSnapshot as DocumentSnapshot<Map<String, dynamic>>?;
      if (userMap == null || userMap.data() == null) return null;

      var user = UserData.fromJson((userMap).data()!);
      log("getUserInfo-uid: ${user.toString()}");

      return user;
    } catch (e) {
      log("getUserInfo get user info fail: $e");
      return null;
    }
  }

  Future<Trip?> getTripDetail(String? tripId) async {
    try {
      log("getTripDetail-uid: $tripId");
      if (tripId == null || tripId.isEmpty) {
        return null;
      }

      DocumentSnapshot tripSnapshot = await _router.doc(tripId).get();
      if (!tripSnapshot.exists) {
        return null;
      }

      DocumentSnapshot<Map<String, dynamic>>? tripMap =
          tripSnapshot as DocumentSnapshot<Map<String, dynamic>>?;
      if (tripMap == null || tripMap.data() == null) return null;

      var tripData = Trip.fromJson((tripMap).data()!);
      log("getTripDetail-uid: ${tripData.toString()}");

      return tripData;
    } catch (e) {
      log("getTripDetail get user info fail: $e");
      return null;
    }
  }
}
