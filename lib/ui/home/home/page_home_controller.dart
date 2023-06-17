import 'package:appdiphuot/base/base_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../../../model/trip.dart';

class PageHomeController extends BaseController {
  var idItemDetail = "";
  var buttonChoose = 0.obs;
  var listTrips = <Trip>[].obs;
  var listTripWithState = <Trip>[].obs;

  var db = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref().child("files/uid");

  void clearOnDispose() {
    Get.delete<PageHomeController>();
  }

  Future<void> getAllRouter() async {
    setAppLoading(true, "Loading", TypeApp.loadingData);
    await db.collection("router").get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          print('listTrips ${listTrips.length}');
          print('${docSnapshot.id} => ${docSnapshot.data()}');
          listTrips.add(Trip.fromJson(docSnapshot.data()));
        }
        listTripWithState.value = listTrips;
        setAppLoading(false, "Loading", TypeApp.loadingData);
      },
      onError: (e) => {
        setAppLoading(false, "Loading", TypeApp.loadingData),
        print("Error completing: $e")
      },
    );
  }

  List<Trip> getListTrip() {
    return listTrips;
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
  }
}
