import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/db/firebase_helper.dart';
import 'package:appdiphuot/model/trip.dart';
import 'package:appdiphuot/model/user.dart';
import 'package:appdiphuot/ui/user_singleton_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormController extends BaseController {
  var trip = Trip().obs;
  var currentUserData = UserSingletonController.instance.userData;
  var listMember = <UserData>[].obs;

  void clearOnDispose() {
    Get.delete<FormController>();
  }

  Future<void> getRouter(String id) async {
    try {
      FirebaseHelper.collectionReferenceRouter
          .doc(id)
          .snapshots()
          .listen((value) {
        DocumentSnapshot<Map<String, dynamic>>? map =
            value as DocumentSnapshot<Map<String, dynamic>>?;
        if (map == null || map.data() == null) return;

        var trip = Trip.fromJson((map).data()!);
        this.trip.value = trip;
        debugPrint("getRouter success: ${trip.toString()}");

        //gen list member
        _genListMember(this.trip.value.listIdMember ?? List.empty());
      });
    } catch (e) {
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
          }
          listMember.add(user);
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

  void rate() {}
}
