import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/model/user.dart';
import 'package:appdiphuot/ui/user_singleton_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fcm_wrapper/flutter_fcm_wrapper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../../common/const/color_constants.dart';
import '../../../../common/const/constants.dart';
import '../../../../db/firebase_helper.dart';
import '../../../../model/notification_data.dart';
import '../../../../model/push_notification.dart';
import '../../../../model/trip.dart';
import '../../../../util/add_noti_helper.dart';
import '../../../../util/log_dog_utils.dart';

class AddMemberController extends BaseController {
  final _users = FirebaseHelper.collectionReferenceUser;
  final routerCollection = FirebaseHelper.collectionReferenceRouter;

  var allUsers = <UserData>[].obs;
  var userSearchResults = <UserData>[].obs;
  var tripData = Trip().obs;
  var currentUser = UserSingletonController.instance.userData;

  var memberIds = <String>[].obs;
  var membersTripData = <UserData>[].obs;

  String stringSearch = "";

  void clearOnDispose() {
    Get.delete<AddMemberController>();
  }

  void getData(Trip trip) {
    tripData.value = trip;
    memberIds.value = trip.listIdMember ?? [];
    getDetailTrip(trip.id ?? "");
    getAllUsers();
  }

  Future<void> getDetailTrip(String tripID) async {
    try {
      routerCollection
          .doc(tripID)
          .snapshots()
          .listen((value) {
        print('getDetailTrip');
        DocumentSnapshot<Map<String, dynamic>>? tripMap =
        value as DocumentSnapshot<Map<String, dynamic>>?;
        if (tripMap == null || tripMap.data() == null) {
          print('getDetailTrip trip data is null');
          return;
        }

        var trip = Trip.fromJson((tripMap).data()!);
        tripData.value = trip;
        memberIds.value = trip.listIdMember ?? [];
        log("getTripDetail success: ${trip.toString()}");
      });
    } catch (e) {
      log("getTripDetail get user info fail: $e");
    }
  }

  Future<void> searchUser() async {
    if (stringSearch.isEmpty) {
      userSearchResults.value = allUsers.value;
    } else {
      userSearchResults.value = allUsers.value.where((item) {
        return item.name!.toLowerCase().contains(stringSearch) ||
            item.email!.contains(stringSearch) ||
            item.phone!.contains(stringSearch) ||
            item.uid!.contains(stringSearch);
      }).toList();
    }
  }

  Future<void> getAllUsers() async {
    try {
      setAppLoading(true, "Loading", TypeApp.loadingData);
      var userSnapshot = _users.snapshots();

      var userSnapshotMap =
      userSnapshot.map((querySnapshot) => querySnapshot.docs);

      userSnapshotMap.listen((snapshots) {
        List<UserData> tempUserList = [];

        log("searchUser snapshots: $snapshots");
        List<UserData> userTripData = [];
        for (var docSnapshot in snapshots) {
          DocumentSnapshot<Map<String, dynamic>>? userMap =
          docSnapshot as DocumentSnapshot<Map<String, dynamic>>?;

          if (userMap == null || userMap.data() == null) return;

          var user = UserData.fromJson((userMap).data()!);
          tempUserList.add(user);
          log("searchUser user: $user");
          if (memberIds.contains(user.uid) &&
              user.uid != currentUser.value.uid) {
            userTripData.add(user);
          }
        }

        setAppLoading(false, "Loading", TypeApp.loadingData);
        allUsers.value = tempUserList;
        membersTripData.value = userTripData;
        log("searchUser allUser: $tempUserList");
        searchUser();
      });
    } catch (e) {
      setAppLoading(false, "Loading", TypeApp.loadingData);
      log("searchUser get user info fail: $e");
    }
  }

  void addMember(UserData user) {
    try {
      setAppLoading(true, "Loading", TypeApp.loadingData);

      List<String> tempMemberIds = List.from(memberIds);
      tempMemberIds.add(user.uid ?? "");
      tempMemberIds.remove(currentUser.value.uid);

      FirebaseHelper.collectionReferenceRouter.doc(tripData.value.id).update(
        {
          FirebaseHelper.listIdMember: tempMemberIds,
        },
      ).then((value) {
        Dog.d("addMember success");
        postFCMBlockUser(tempMemberIds, user);

        _showToastAddSuccess(user);
        getDetailTrip(tripData.value.id ?? "");
        setAppLoading(false, "Loading", TypeApp.loadingData);
      }).catchError((error) {
        setAppLoading(false, "Loading", TypeApp.loadingData);
        Dog.e("addMember error: $error");
      });
    } catch (e) {
      setAppLoading(false, "Loading", TypeApp.loadingData);
      Dog.e("addMember error: $e");
    }
  }

  Future<void> postFCMBlockUser(List<String> userIDs,
      UserData addedUser) async {
    FlutterFCMWrapper flutterFCMWrapper = const FlutterFCMWrapper(
      apiKey: Constants.apiKey,
      enableLog: true,
      enableServerRespondLog: true,
    );

    try {
      List<String> listFcmToken =
      membersTripData.map((element) => (element.fcmToken ?? "")).toList();
      debugPrint("fcmToken listFcmToken ${listFcmToken.length}");

      String body = "'${addedUser.name}' đã  được mời tham gia chuyến đi";
      String title =
          "'${addedUser.name}' đã  được mời tham gia chuyến đi '${tripData.value
          .title}'";
      PushNotification notification = PushNotification(
        title: title,
        body: body,
        dataTitle: null,
        dataBody: body,
        tripName: tripData.value.title,
        tripID: tripData.value.id,
        userName: currentUser.value.name,
        userAvatar: currentUser.value.avatar,
        notificationType: NotificationData.TYPE_INVITE_TRIP,
        time: DateTime
            .now()
            .millisecondsSinceEpoch
            .toString(),
      );

      for (var element in userIDs) {
        AddNotificationHelper.addNotification(notification, element);
      }

      Map<String, dynamic> result =
      await flutterFCMWrapper.sendMessageByTokenID(
        userRegistrationTokens: listFcmToken,
        title: title,
        body: body,
        androidChannelID: DateTime
            .now()
            .microsecondsSinceEpoch
            .toString(),
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      );

      Dog.d("FCM sendTopicMessage fcmToken result $result");
    } catch (e) {
      Dog.e("FCM sendTopicMessage fcmToken $e");
    }
  }

  void _showToastAddSuccess(UserData user) {
    Fluttertoast.showToast(
        msg: "Đã mời ${user.name} tham gia chuyến đi",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorConstants.appColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
