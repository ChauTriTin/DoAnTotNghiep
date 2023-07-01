import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/db/firebase_helper.dart';
import 'package:appdiphuot/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../model/trip.dart';

class MemberController extends BaseController {
  final _users = FirebaseHelper.collectionReferenceUser;
  var members = <UserData>[].obs;
  var tripData = Trip().obs;

  void clearOnDispose() {
    Get.delete<MemberController>();
  }

  void getData() {
    getAllMember();
  }

  Future<void> getAllMember() async {
    try {
      if (tripData.value.listIdMember == null || tripData.value.listIdMember?.isEmpty == true) return;
      var tempUserList = <UserData>[];
      for (var uid in tripData.value.listIdMember!) {
        DocumentSnapshot userSnapshot = await _users.doc(uid).get();
        if (!userSnapshot.exists) {
          continue;
        }

        DocumentSnapshot<Map<String, dynamic>>? userMap = userSnapshot as DocumentSnapshot<Map<String, dynamic>>?;
        if (userMap == null || userMap.data() == null) return;

        var user = UserData.fromJson((userMap).data()!);
        tempUserList.add(user);
        log("_getUserParticipated success: ${user.toString()}");
      }
      members.value = tempUserList;
    } catch (e) {
      log("_getUserParticipated get user info fail: $e");
    }
  }
}
