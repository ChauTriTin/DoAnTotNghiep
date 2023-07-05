import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/db/firebase_helper.dart';
import 'package:appdiphuot/model/trip.dart';
import 'package:appdiphuot/ui/user_singleton_controller.dart';
import 'package:appdiphuot/util/log_dog_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fcm_wrapper/flutter_fcm_wrapper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/const/constants.dart';
import '../../../../model/user.dart';

class CreateSuccessController extends BaseController {
  var isDoneCountdown = false.obs;
  var trip = Trip().obs;
  var listMember = <UserData>[].obs;
  var listFCMToken = <String>[].obs;
  var currentUserData = UserSingletonController.instance.userData;
  var isTripDeleted = false.obs;
  var shouldShowEditButton = false.obs;

  void clearOnDispose() {
    Get.delete<CreateSuccessController>();
  }

  void setDoneCountdown(bool value) {
    isDoneCountdown.value = value;
  }

  bool checkShowEditBtn() {
    String uid = UserSingletonController.instance.getUid();
    Dog.d("shouldShowEditButton: ${trip.value.toString()}, uid: $uid");
    return trip.value.userIdHost == uid
        && (trip.value.isComplete == null || trip.value.isComplete == false);
  }

  Future<void> getRouter(String id) async {
    try {
      FirebaseHelper.collectionReferenceRouter
          .doc(id)
          .snapshots()
          .listen((value) {
        if (!value.exists) {
          print('getDetailTrip trip does not exist.');
          isTripDeleted.value = true;
        }

        DocumentSnapshot<Map<String, dynamic>>? map =
            value as DocumentSnapshot<Map<String, dynamic>>?;
        if (map == null || map.data() == null) return;

        var trip = Trip.fromJson((map).data()!);
        this.trip.value = trip;
        debugPrint("getRouter success: ${trip.toString()}");

        //gen list router
        var pStart = this.trip.value.placeStart;
        var pEnd = this.trip.value.placeEnd;
        var list = this.trip.value.listPlace;
        isTripDeleted.value = false;

        shouldShowEditButton.value = checkShowEditBtn();
        Dog.d("shouldShowEditButton: ${shouldShowEditButton.value}");
        // if (pStart != null && pEnd != null && list != null) {
        //   _initRouter(pStart, pEnd, list);
        // }

        //gen list member
        _genListMember(this.trip.value.listIdMember ?? List.empty());
      });
    } catch (e) {
      isTripDeleted.value = true;
      debugPrint("getRouter get user info fail: $e");
    }
  }

  void _genListMember(List<String> listIdMember) {
    listMember.clear();

    for (int i = 0; i < listIdMember.length; i++) {
      try {
        String id = listIdMember[i];
        FirebaseHelper.collectionReferenceUser
            .doc(id)
            .snapshots()
            .listen((value) {
          DocumentSnapshot<Map<String, dynamic>>? userMap =
          value as DocumentSnapshot<Map<String, dynamic>>?;
          if (userMap == null || userMap.data() == null) return;

          var user = UserData.fromJson((userMap).data()!);
          debugPrint("_genListMember index $i: ${user.toJson()}");

          var indexContain = hasContainUserInListMember(user);
          debugPrint("getLocation indexContain $indexContain");
          if (indexContain >= 0) {
            listMember.removeAt(indexContain);
            listFCMToken.removeAt(indexContain);
          }
          if (user.uid != currentUserData.value.uid) {
            listMember.add(user);
            listFCMToken.add(user.fcmToken ?? "");
          }
          debugPrint("_genListMember success listMember length ${listMember.length}");
        });
      } catch (e) {
        debugPrint("_genListMember get user info fail: $e");
      }
    }

    debugPrint("_genListMember success listMember length ${listMember.length}");
    listMember.refresh();
  }

  int hasContainUserInListMember(UserData userData) {
    for (int i = 0; i < listMember.length; i++) {
      if (userData.uid == listMember[i].uid) {
        return i;
      }
    }
    return -1;
  }

  // DateTime getDateTimeEnd() {
  //   try {
  //     var dateTimeEnd = trip.value.timeEnd ?? "";
  //     debugPrint("getDateTimeEnd dateTimeEnd $dateTimeEnd");
  //     DateTime tempDate = DateFormat("dd/MM/yyyy HH:mm").parse(dateTimeEnd);
  //     debugPrint("getDateTimeEnd tempDate $tempDate");
  //     return tempDate;
  //   } catch (e) {
  //     debugPrint("getDateTimeEnd error: $e");
  //     return DateTime.now().add(const Duration(days: 7));
  //   }
  // }

  DateTime getDateTimeStart() {
    try {
      var dateTimeStart = trip.value.timeStart ?? "";
      debugPrint("dateTimeStart dateTimeStart $dateTimeStart");
      DateTime tempDate = DateFormat("dd/MM/yyyy HH:mm").parse(dateTimeStart);
      debugPrint("getDateTimeStart tempDate $tempDate");
      return tempDate;
    } catch (e) {
      debugPrint("dateTimeStart error: $e");
      return DateTime.now().add(const Duration(days: 7));
    }
  }

  Future<void> outTrip() async {
    try {
      setAppLoading(true, "Loading", TypeApp.loadingData);
      var listIdMember = trip.value.listIdMember;
      Dog.d("outTrip currentIdMember: ${listIdMember.toString()}");
      listIdMember?.remove(UserSingletonController.instance.getUid());
      // Get the reference to the document you want to update
      DocumentReference documentRef =
      FirebaseHelper.collectionReferenceRouter.doc(trip.value.id);

      // Dog.d("removeMember listIdMemberJson: $listIdMemberJson - ${tripData.value.id}");
      // Update the specific field
      documentRef.update({FirebaseHelper.listIdMember: listIdMember}).then((value) {
        Dog.d("outTrip success");
        setAppLoading(false, "Loading", TypeApp.loadingData);
        postFCM("${currentUserData.value.name} ${StringConstants.informOutRouter} ${trip.value.title}.");
      }).catchError((error) {
        setAppLoading(false, "Loading", TypeApp.loadingData);
        Dog.e("outTrip error: $error");
      });
    } catch (e) {
      setAppLoading(false, "Loading", TypeApp.loadingData);
      Dog.e("outTrip error: $e");
    }
  }

  Future<void> postFCM(String body,) async {
    FlutterFCMWrapper flutterFCMWrapper = const FlutterFCMWrapper(
      apiKey: Constants.apiKey,
      enableLog: true,
      enableServerRespondLog: true,
    );
    try {
      debugPrint("fcmToken listFcmToken ${listFCMToken.length}");
      Map<String, dynamic> result =
      await flutterFCMWrapper.sendMessageByTokenID(
        userRegistrationTokens: listFCMToken,
        title: "Thông báo",
        body: body,
        androidChannelID: DateTime.now().microsecondsSinceEpoch.toString(),
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      );
      debugPrint("FCM sendTopicMessage fcmToken result $result");
    } catch (e) {
      debugPrint("FCM sendTopicMessage fcmToken $e");
    }
  }
}
