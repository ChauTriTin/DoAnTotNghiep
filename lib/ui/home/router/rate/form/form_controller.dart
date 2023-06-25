import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/db/firebase_helper.dart';
import 'package:appdiphuot/model/rate.dart';
import 'package:appdiphuot/model/trip.dart';
import 'package:appdiphuot/model/user.dart';
import 'package:appdiphuot/ui/user_singleton_controller.dart';
import 'package:appdiphuot/util/log_dog_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormController extends BaseController {
  var trip = Trip().obs;
  var currentUserData = UserSingletonController.instance.userData;
  var listMember = <UserData>[].obs;
  var rateLeader = 0.0.obs;
  var rateTrip = 0.0.obs;
  var ratePlaceStart = 0.0.obs;
  var ratePlaceEnd = 0.0.obs;
  var rateListPlaceStop = [].obs;

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

        //set default value for rate list place stop
        this.trip.value.listPlace?.forEach((element) {
          rateListPlaceStop.add(0.0);
        });

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

  void rate(VoidCallback voidCallback) {
    Rate rate = Rate();
    rate.rateLeader = rateLeader.value;
    rate.rateTrip = rateTrip.value;
    rate.ratePlaceStart = ratePlaceStart.value;
    rate.ratePlaceEnd = ratePlaceEnd.value;

    var listTmp = <double>[];
    for (var element in rateListPlaceStop) {
      listTmp.add(element);
    }
    rate.rateListPlaceStop = listTmp;
    Dog.e(">>>rate ${rate.toJson()}");

    try {
      var tripId = trip.value.id;
      if (tripId == null || tripId.isEmpty) {
        return;
      }
      trip.value.rate = rate;
      Dog.e(">>>rate trip ${trip.toJson()}");
      FirebaseHelper.collectionReferenceRouter.doc(tripId).update({
        "rate": rate.toJson(),
      });
      Dog.e(">>>rate success");
    } catch (e) {
      Dog.e(">>>rate err $e");
    }
    voidCallback.call();
  }

  void setRateLeader(double value) {
    rateLeader.value = value;
  }

  void setRateTrip(double value) {
    rateTrip.value = value;
  }

  void setPlaceStart(double value) {
    ratePlaceStart.value = value;
  }

  void setPlaceEnd(double value) {
    ratePlaceEnd.value = value;
  }

  void setPlaceStopWithIndex(double value, int index) {
    rateListPlaceStop[index] = value;
  }
}
