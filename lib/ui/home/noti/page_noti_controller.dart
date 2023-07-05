import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/model/push_notification.dart';
import 'package:appdiphuot/util/log_dog_utils.dart';
import 'package:appdiphuot/util/shared_preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../db/firebase_helper.dart';
import '../../user_singleton_controller.dart';

class PageNotiController extends BaseController {
  var listNotification = <PushNotification>[].obs;
  var notificationCollection = FirebaseHelper.collectionReferenceNotification;
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

      var chatSnapshots =
          notificationStream.map((querySnapshot) => querySnapshot.docs);

      chatSnapshots.listen((chatSnapshots) {
        log("getNotification: Update message");
        var tempNotifications = <PushNotification>[];

        for (var chatSnapshot in chatSnapshots) {
          DocumentSnapshot<Map<String, dynamic>>? notification = chatSnapshot;

          if (notification.data() == null) return;

          var trip = PushNotification.fromJson((notification).data()!);
          tempNotifications.insert(0, trip);
        }

        listNotification.value = tempNotifications;
      });
    } catch (e) {
      Dog.e("getNotification error: ${e.toString()}");
    }
  }
}
