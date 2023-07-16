import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/db/firebase_helper.dart';
import 'package:appdiphuot/model/loc_search.dart';
import 'package:appdiphuot/model/rate.dart';
import 'package:appdiphuot/model/trip.dart';
import 'package:appdiphuot/model/user.dart';
import 'package:appdiphuot/model/user_rate.dart';
import 'package:appdiphuot/ui/user_singleton_controller.dart';
import 'package:appdiphuot/util/log_dog_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormController extends BaseController {
  var trip = Trip().obs;
  var currentUserData = UserSingletonController.instance.userData;
  var listMember = <UserData>[].obs;
  var userHost = UserData();
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
      debugPrint(">>>rate getRouter FCM main id $id");
      FirebaseHelper.collectionReferenceRouter
          .doc(id)
          .snapshots()
          .listen((value) {
        DocumentSnapshot<Map<String, dynamic>>? map =
            value as DocumentSnapshot<Map<String, dynamic>>?;
        debugPrint(">>>rate map id ${map?.id}");
        debugPrint(">>>rate map data ${map?.data()}");
        if (map == null || map.data() == null) {
          debugPrint(">>>rate map == null || map.data() == null return");
          return;
        }

        var trip = Trip.fromJson((map).data()!);
        debugPrint(">>>rate trip: ${trip.toJson()}");
        debugPrint(">>>rate trip rates: ${trip.rates.toString()}");
        this.trip.value = trip;
        debugPrint(">>>rate getRouter success: ${this.trip.value.toJson()}");

        //set default value for rate list place stop
        this.trip.value.listPlace?.forEach((element) {
          rateListPlaceStop.add(0.0);
        });

        //gen list member
        _genListMember(this.trip.value.listIdMember ?? List.empty());
      });
    } catch (e) {
      debugPrint(">>>rate getRouter get user info fail: $e");
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
          if (user.uid == trip.value.userIdHost) {
            userHost = user;
          }
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
    rate.idUser = currentUserData.value.uid;
    rate.rateLeader = rateLeader.value;
    rate.rateTrip = rateTrip.value;
    rate.ratePlaceStart = ratePlaceStart.value;
    rate.ratePlaceEnd = ratePlaceEnd.value;

    var rateUser =
        UserRate(trip.value.userIdHost, trip.value.id, rate.rateLeader);
    addRateToUserCollection(rateUser, trip.value);

    var listTmp = <double>[];
    for (var element in rateListPlaceStop) {
      listTmp.add(element);
    }
    rate.rateListPlaceStop = listTmp;
    debugPrint(">>>rate ${rate.toJson()}");

    try {
      var tripId = trip.value.id;
      if (tripId == null || tripId.isEmpty) {
        debugPrint(">>>rate tripId == null || tripId.isEmpty return");
        return;
      }
      debugPrint(">>>rate trip ${trip.value.toJson()}");
      // debugPrint(">>>rate currentUserData.value.uid ${currentUserData.value.uid}");

      // var index = -1;
      // var mapRate = trip.value.rates ?? {};
      // var length = mapRate.length;
      // debugPrint(">>>rate mapRate $mapRate");
      // var mapRateList = mapRate.values.toList();
      // for (int i = 0; i < length; i++) {
      //   var r = Rate.fromJson(mapRateList[i]);
      //   debugPrint(">>>rate r ${r.toString()}");
      //   debugPrint(
      //       ">>>rate i $i -> ${r.idUser} - ${currentUserData.value.uid}");
      //   if (r.idUser == currentUserData.value.uid) {
      //     index = i;
      //   }
      // }
      // debugPrint(">>>rate index $index");

      Map<String, dynamic> map = {};
      var rates = trip.value.rates;
      if (rates != null) {
        map.addAll(rates);
      }
      map.addEntries({"${rate.idUser}": rate.toJson()}.entries);

      debugPrint(">>>rate map $map");
      FirebaseHelper.collectionReferenceRouter
          .doc(tripId)
          .update({"rates": map});
      debugPrint(">>>rate success");
    } catch (e) {
      debugPrint(">>>rate err $e");
    }

    var districtPlaceStart = trip.value.placeStart?.district;
    debugPrint(
        ">>>districtPlaceStart $districtPlaceStart, ratePlaceStart ${rate.ratePlaceStart}");
    if (districtPlaceStart == null || districtPlaceStart.isEmpty) {
      //do nothing
    } else {
      postFirebaseSearchLoc(districtPlaceStart, rate.ratePlaceStart?.toInt());
    }

    var districtPlaceEnd = trip.value.placeEnd?.district;
    if (districtPlaceEnd == null || districtPlaceEnd.isEmpty) {
      //do nothing
    } else {
      postFirebaseSearchLoc(districtPlaceEnd, rate.ratePlaceEnd?.toInt());
    }

    voidCallback.call();
  }

  void postFirebaseSearchLoc(String key, int? rate) {
    if (rate == null) {
      return;
    }
    try {
      //get old value
      var stopListen = false;
      CollectionReference collectionRef = FirebaseHelper.collectionReferenceLoc;

      collectionRef.doc(key).snapshots().listen((value) {
        if (stopListen) {
          return;
        } else {
          stopListen = true;
        }
        DocumentSnapshot<Map<String, dynamic>>? map =
            value as DocumentSnapshot<Map<String, dynamic>>?;

        if (map == null || map.data() == null) {
          debugPrint("postFirebaseSearchLoc return -> does not exit");
        } else {
          var oldLocSearch = LocSearch.fromJson((map).data()!);
          debugPrint(
              "postFirebaseSearchLoc oldLocSearch before ${oldLocSearch.toJson()}");
          var newListRate = oldLocSearch.listRate;
          newListRate?.add(rate);
          oldLocSearch.listRate = newListRate;
          debugPrint(
              "postFirebaseSearchLoc oldLocSearch after ${oldLocSearch.toJson()}");

          //listen once
          // collectionRef.doc(key).snapshots().listen((_) {}).cancel();

          FirebaseHelper.collectionReferenceLoc
              .doc(key)
              .set(oldLocSearch.toJson())
              .then((value) {
            debugPrint("postFirebaseSearchLoc value success");
          }).catchError((e) {
            debugPrint("postFirebaseSearchLoc catchError $e");
          });
        }
      });
    } catch (e) {
      debugPrint("postFirebaseSearchLoc catch $e");
    }
  }

  Future<void> addRateToUserCollection(UserRate rate, Trip trip) async {
    try {
      List<UserRate> rates = userHost.rates ?? [];
      rates.insert(0, rate);

      // Map<String, dynamic> map = {};
      // for (UserRate element in rates) {
      //   map.addEntries(element.idUser: element.to());
      // }

      List<Map<String, dynamic>> rateMaps =
          rates.map((rate) => rate.toJson()).toList();

      Dog.d("addRateToUserCollection: ${rate.toString()}");
      await FirebaseHelper.collectionReferenceUser
          .doc(trip.userIdHost)
          .update({FirebaseHelper.rates: rateMaps});
    } catch (e) {
      Dog.e("_addMessageToFireStore fail: $e");
    }
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

  UserData? getLeaderInfor() {
    var idHost = trip.value.userIdHost;
    UserData? leaderInfo;
    for (var element in listMember) {
      if (element.uid == idHost) {
        leaderInfo = element;
        break;
      }
    }
    return leaderInfo;
  }
}
