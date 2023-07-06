import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/db/firebase_helper.dart';
import 'package:appdiphuot/model/loc_search.dart';
import 'package:appdiphuot/util/log_dog_utils.dart';
import 'package:appdiphuot/util/shared_preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../../../common/const/string_constants.dart';
import '../../../model/trip.dart';

class PageHomeController extends BaseController {
  var idItemDetail = "";
  var buttonChoose = 0.obs;
  var buttonChipTypeSelected = StringConstants.tripOpen.obs;
  var listTrips = <Trip>[].obs;
  var listTripWithState = <Trip>[].obs;
  var listTripWithSearch = <Trip>[].obs;
  var listLocation = <LocSearch>[].obs;
  String? selectedValue;

  var db = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref().child("files/uid");

  void clearOnDispose() {
    Get.delete<PageHomeController>();
  }

  Future<void> getData() async {

  }

  Future<void> getLocationSearch() async {
    var locSearchSnapshot = FirebaseHelper.collectionReferenceLoc.snapshots();
    var locSearchSnapshotMap =
    locSearchSnapshot.map((querySnapshot) => querySnapshot.docs);

    locSearchSnapshotMap.listen((event) {
      try {
        listLocation.clear();
        for (var docSnapshot in event) {
          DocumentSnapshot<Map<String, dynamic>>? locMap =
          docSnapshot as DocumentSnapshot<Map<String, dynamic>>?;

          if (locMap == null || locMap.data() == null) return;

          var loc = LocSearch.fromJson((locMap).data()!);
          listLocation.add(loc);
        }
      }catch(ex){
        print('listLocation error ${ex}');
      }
    });
  }

  Future<void> getAllRouter() async {
    setAppLoading(true, "Loading", TypeApp.loadingData);
    var routerSnapshot = FirebaseHelper.collectionReferenceRouter.snapshots();
    var routerSnapshotsMap =
        routerSnapshot.map((querySnapshot) => querySnapshot.docs);

    routerSnapshotsMap.listen((routerSnapshots) {
      try {
        listTrips.clear();
        for (var docSnapshot in routerSnapshots) {
          DocumentSnapshot<Map<String, dynamic>>? tripMap =
              docSnapshot as DocumentSnapshot<Map<String, dynamic>>?;

          if (tripMap == null || tripMap.data() == null) return;

          var trip = Trip.fromJson((tripMap).data()!);
          listTrips.add(trip);
        }

        print('listTrips ${listTrips.length}');

        listTripWithState.value = listTrips;
        listTripWithSearch.value =
            listTrips.where((p0) => p0.isComplete == false).toList();
        setAppLoading(false, "Loading", TypeApp.loadingData);

        Dog.d("selectedValue: $selectedValue");
        if (selectedValue?.isNotEmpty == true) {
          setTypeTrip(selectedValue!);
        }
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
    buttonChipTypeSelected.value = type;
    filterTrip();
  }

  void setButtonChoose(int number) {
    buttonChoose.value = number;
    filterTrip();
  }

  void filterTrip() {
    var filteredTrip = <Trip>[];

    var filteredListTripType = <Trip>[];
    switch (buttonChipTypeSelected.value) {
      case StringConstants.tripOpen:
        var temp = listTrips.where((p0) => p0.isComplete == false);
        filteredListTripType.addAll(temp);
        break;
      case StringConstants.tripPost:
        var temp = listTrips.where((p0) => p0.isComplete == true);
        filteredListTripType.addAll(temp);
        break;
      case StringConstants.tripTop:
        listTrips.sort((a, b) {
          var aLength = a.listIdMember?.length ?? 1;
          var bLength = b.listIdMember?.length ?? 1;

          return bLength.compareTo(aLength);
        });
        filteredListTripType = listTrips;
        break;
      case StringConstants.placeTop:
        listLocation.sort((a, b) => b.count!.compareTo(a.count as num));
        break;
    }

    switch (buttonChoose.value) {
      case 0:
        filteredTrip.addAll(filteredListTripType);
        break;
      case 1:
        filteredTrip =
            filteredListTripType.where((i) => i.isPublic == true).toList();
        break;
      case 2:
        filteredTrip =
            filteredListTripType.where((i) => i.isPublic == false).toList();
        break;
    }

    listTripWithState.value = filteredTrip;
    listTripWithSearch.value = filteredTrip;
  }
}
