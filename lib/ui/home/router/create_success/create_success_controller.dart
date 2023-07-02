import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/db/firebase_helper.dart';
import 'package:appdiphuot/model/trip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateSuccessController extends BaseController {
  var isDoneCountdown = false.obs;
  var trip = Trip().obs;
  var isTripDeleted = false.obs;

  void clearOnDispose() {
    Get.delete<CreateSuccessController>();
  }

  void setDoneCountdown(bool value) {
    isDoneCountdown.value = value;
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
        // if (pStart != null && pEnd != null && list != null) {
        //   _initRouter(pStart, pEnd, list);
        // }

        //gen list member
        // _genListMember(this.trip.value.listIdMember ?? List.empty());
      });
    } catch (e) {
      isTripDeleted.value = true;
      debugPrint("getRouter get user info fail: $e");
    }
  }

  DateTime getDateTimeEnd() {
    try {
      var dateTimeEnd = trip.value.timeEnd ?? "";
      debugPrint("getDateTimeEnd dateTimeEnd $dateTimeEnd");
      DateTime tempDate = DateFormat("dd/MM/yyyy HH:mm").parse(dateTimeEnd);
      debugPrint("getDateTimeEnd tempDate $tempDate");
      return tempDate;
    } catch (e) {
      debugPrint("getDateTimeEnd error: $e");
      return DateTime.now().add(const Duration(days: 7));
    }
  }
}
