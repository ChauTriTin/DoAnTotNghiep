import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../db/firebase_helper.dart';
import '../../../../model/trip.dart';
import '../../../../util/log_dog_utils.dart';

class AddMemberController extends BaseController {
  final _users = FirebaseHelper.collectionReferenceUser;

  var allUsers = <UserData>[].obs;
  var userSearchResults = <UserData>[].obs;
  var tripData = Trip().obs;
  var memberIds = <String>[].obs;

  String stringSearch = "";

  void clearOnDispose() {
    Get.delete<AddMemberController>();
  }

  void getData(String tripID) {
    getDetailTrip(tripID);
    getAllUsers();
  }

  Future<void> getDetailTrip(String tripID) async {
    try {
      FirebaseHelper.collectionReferenceRouter
          .doc(tripID)
          .snapshots()
          .listen((value) {
        if (!value.exists) {
          print('getDetailTrip trip does not exist.');
        }
        DocumentSnapshot<Map<String, dynamic>>? tripMap =
            value as DocumentSnapshot<Map<String, dynamic>>?;
        if (tripMap == null || tripMap.data() == null) return;

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
        for (var docSnapshot in snapshots) {
          DocumentSnapshot<Map<String, dynamic>>? userMap =
              docSnapshot as DocumentSnapshot<Map<String, dynamic>>?;

          if (userMap == null || userMap.data() == null) return;

          var user = UserData.fromJson((userMap).data()!);
          tempUserList.add(user);
          log("searchUser user: $user");
        }

        setAppLoading(false, "Loading", TypeApp.loadingData);
        allUsers.value = tempUserList;
        log("searchUser allUser: $tempUserList");
        searchUser();
      });
    } catch (e) {
      setAppLoading(false, "Loading", TypeApp.loadingData);
      log("searchUser get user info fail: $e");
    }
  }

  void addMember(UserData user) {}
}
