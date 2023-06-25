import 'package:appdiphuot/base/base_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../../../common/const/string_constants.dart';
import '../../../model/trip.dart';

class PageHomeController extends BaseController {
  var idItemDetail = "";
  var buttonChoose = 0.obs;
  var listTrips = <Trip>[].obs;
  var listTripWithState = <Trip>[].obs;
  var listTripWithSearch = <Trip>[].obs;

  var db = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref().child("files/uid");

  void clearOnDispose() {
    Get.delete<PageHomeController>();
  }

  Future<void> getAllRouter() async {
    setAppLoading(true, "Loading", TypeApp.loadingData);
    var routerSnapshot = db.collection("router").snapshots();
    routerSnapshot.listen((event) {
      try {
        for (var docSnapshot in event.docs) {
          var trip = Trip.fromJson(docSnapshot.data().cast<String, dynamic>());
          if (listTrips.firstWhereOrNull(
                  (element) => element.id == docSnapshot.id) ==
              null) {
            listTrips
                .add(Trip.fromJson(docSnapshot.data().cast<String, dynamic>()));
          } else {
            if (listTrips.firstWhereOrNull(
                    (element) => element.id == docSnapshot.id) ==
                trip) {
              var index =
                  listTrips.indexWhere((element) => element.id == trip.id);
              listTrips[index] = trip;
            }
          }

          print('listTrips ${listTrips.length}');
        }
        listTripWithState.value = listTrips;
        listTripWithSearch.value =
            listTrips.where((p0) => p0.isComplete == false).toList();
        setAppLoading(false, "Loading", TypeApp.loadingData);
      } catch (ex) {
        print('listTrips error ${ex}');
        setAppLoading(false, "Loading", TypeApp.loadingData);
      }
    });
  }

  List<Trip> getListTrip() {
    return listTrips;
  }

  void setTypeTrip(String type) {
    var list = <Trip>[];

    switch (type) {
      case StringConstants.tripOpen:
        var temp = listTrips.where((p0) => p0.isComplete == false);
        list.addAll(temp);
        break;
      case StringConstants.tripPost:
        var temp = listTrips.where((p0) => p0.isComplete == true);
        list.addAll(temp);
        break;
      case StringConstants.tripTop:
        listTrips.sort((a, b) {
          var aLength = a.listIdMember?.length ?? 1;
          var bLength = b.listIdMember?.length ?? 1;

          return bLength.compareTo(aLength);
        });
        list = listTrips;
        break;
      case StringConstants.placeTop:
        // list = listTrips.where((i) => i.isPublic == false).toList();
        break;
    }

    listTripWithState.value = list;
    listTripWithSearch.value = list;
  }

  void setButtonChoose(int number) {
    buttonChoose.value = number;

    var list = <Trip>[];

    switch (buttonChoose.value) {
      case 0:
        list.addAll(listTrips);
        break;
      case 1:
        list = listTrips.where((i) => i.isPublic == true).toList();
        break;
      case 2:
        list = listTrips.where((i) => i.isPublic == false).toList();
        break;
    }

    listTripWithState.value = list;
    listTripWithSearch.value = list;
  }
}
