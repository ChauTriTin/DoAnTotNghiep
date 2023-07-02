import 'dart:convert';
import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/db/firebase_helper.dart';
import 'package:appdiphuot/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../model/trip.dart';
import '../../../../util/log_dog_utils.dart';

class MemberController extends BaseController {
  final _users = FirebaseHelper.collectionReferenceUser;
  var members = <UserData>[].obs;
  var tripData = Trip().obs;
  var isTripCompleted = false.obs;
  var isTripDeleted = false.obs;

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

  void removeMember(UserData user) {
    try {
      setAppLoading(true, "Loading", TypeApp.loadingData);
      var listIdMember = tripData.value.listIdMember;
      Dog.d("removeMember currentIdMember: ${listIdMember.toString()}");
      listIdMember?.remove(user.uid);
      // Get the reference to the document you want to update
      DocumentReference documentRef =
      FirebaseHelper.collectionReferenceRouter.doc(tripData.value.id);


      // Dog.d("removeMember listIdMemberJson: $listIdMemberJson - ${tripData.value.id}");
      // Update the specific field
      documentRef.update({FirebaseHelper.listIdMember: listIdMember}).then((value) {
        Dog.d("removeMember success");
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

}
