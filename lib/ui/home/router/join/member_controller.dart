import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/db/firebase_helper.dart';
import 'package:appdiphuot/model/user.dart';
import 'package:appdiphuot/ui/user_singleton_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_fcm_wrapper/flutter_fcm_wrapper.dart';
import 'package:get/get.dart';

import '../../../../common/const/constants.dart';
import '../../../../common/const/string_constants.dart';
import '../../../../model/notification_data.dart';
import '../../../../model/push_notification.dart';
import '../../../../model/trip.dart';
import '../../../../util/add_noti_helper.dart';
import '../../../../util/log_dog_utils.dart';
import '../../../../util/time_utils.dart';

class MemberController extends BaseController {
  final _users = FirebaseHelper.collectionReferenceUser;
  var members = <UserData>[].obs;
  var tripData = Trip().obs;
  var isTripCompleted = false.obs;
  var isTripDeleted = false.obs;
  var currentUserID = UserSingletonController.instance.getUid();
  var currentUserUser = UserSingletonController.instance.userData;

  void clearOnDispose() {
    Get.delete<MemberController>();
  }

  void getData() {
    getTripDetail();
  }

  Future<void> getAllMember() async {
    try {
      setAppLoading(true, "Loading", TypeApp.loadingData);
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
      setAppLoading(false, "Loading", TypeApp.loadingData);
      members.value = tempUserList;
    } catch (e) {
      setAppLoading(false, "Loading", TypeApp.loadingData);
      log("_getUserParticipated get user info fail: $e");
    }
  }

  void removeMember(UserData user, bool isBlock) {
    try {
      setAppLoading(true, "Loading", TypeApp.loadingData);
      var listIdMember = tripData.value.listIdMember;
      var listIdMemberBlocked = tripData.value.listIdMemberBlocked ?? [];

      Dog.d("outTrip currentIdMember: ${listIdMember.toString()}");
      Dog.d("outTrip listIdMemberBlocked: ${listIdMemberBlocked.toString()}");

      listIdMember?.remove(user.uid);
      listIdMemberBlocked.add(user.uid ?? "");

      FirebaseHelper.collectionReferenceRouter.doc(tripData.value.id).update(
        {
          FirebaseHelper.listIdMember: listIdMember,
          if (isBlock) FirebaseHelper.listIdMemberBlocked: listIdMemberBlocked
        },
      ).then((value) {
        Dog.d("removeMember success");
        postFCMBlockUser(user, isBlock);
        setAppLoading(false, "Loading", TypeApp.loadingData);
      }).catchError((error) {
        setAppLoading(false, "Loading", TypeApp.loadingData);
        Dog.e("removeMember error: $error");
      });
    } catch (e) {
      setAppLoading(false, "Loading", TypeApp.loadingData);
      Dog.e("removeMember error: $e");
    }
  }

  Future<void> getTripDetail() async {
    try {
      log("getTripDetail-uid: ${tripData.value.id}");
      FirebaseHelper.collectionReferenceRouter
          .doc(tripData.value.id)
          .snapshots()
          .listen((value) {
        if (!value.exists) {
          print('getDetailTrip trip does not exist.');
          isTripDeleted.value = true;
        }

        DocumentSnapshot<Map<String, dynamic>>? tripMap =
            value as DocumentSnapshot<Map<String, dynamic>>?;
        if (tripMap == null || tripMap.data() == null) return;

        var trip = Trip.fromJson((tripMap).data()!);
        tripData.value = trip;

        isTripCompleted.value = trip.isComplete ?? false;
        log("getTripDetail success: ${trip.toString()}");
        getAllMember();
        isTripDeleted.value = false;
      });
    } catch (e) {
      isTripDeleted.value = true;
      log("getTripDetail get user info fail: $e");
    }
  }

  Future<void> postFCMBlockUser(UserData userBlock, bool isBlock) async {
    FlutterFCMWrapper flutterFCMWrapper = const FlutterFCMWrapper(
      apiKey: Constants.apiKey,
      enableLog: true,
      enableServerRespondLog: true,
    );
    try {
      var listFcmToken = <String>[];
      var memberIdsSendNoti = <String>[];
      for (var element in members) {
        var fcmToken = element.fcmToken;
        if (fcmToken != null &&
            fcmToken.isNotEmpty &&
            fcmToken != currentUserUser.value.fcmToken) {
          if (fcmToken == userBlock.fcmToken) {
            listFcmToken.add(fcmToken);
            if (element.uid != null && element.uid!.isNotEmpty) {
              memberIdsSendNoti.add(element.uid!);
            }
          }
        }
      }
      debugPrint("fcmToken listFcmToken ${listFcmToken.length}");

      var title = "";
      String body = "";
      if (isBlock) {
        body = "${currentUserUser.value.name} đã bị kick khỏi chuyến đi";
        title =
            "${currentUserUser.value.name} vừa kick ${userBlock.name} ra khỏi chuyến đi ${tripData.value.title}";
      } else {
        body = "${currentUserUser.value.name} đã rời khỏi chuyến đi";
        title =
            "${currentUserUser.value.name} đã rời khỏi chuyến đi '${tripData.value.title}'";
      }

      PushNotification notification = PushNotification(
        title: title,
        body: body,
        dataTitle: null,
        dataBody: body,
        tripName: tripData.value.title,
        tripID: tripData.value.id,
        userName: currentUserUser.value.name,
        userAvatar: currentUserUser.value.avatar,
        notificationType: NotificationData.TYPE_REMOVE,
        time: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      for (var element in memberIdsSendNoti) {
        AddNotificationHelper.addNotification(notification, element);
      }

      Map<String, dynamic> result =
          await flutterFCMWrapper.sendMessageByTokenID(
        userRegistrationTokens: listFcmToken,
        title: title,
        body: body,
        androidChannelID: DateTime.now().microsecondsSinceEpoch.toString(),
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      );

      Dog.e("FCM sendTopicMessage fcmToken result $result");
    } catch (e) {
      Dog.e("FCM sendTopicMessage fcmToken $e");
    }
  }
}
