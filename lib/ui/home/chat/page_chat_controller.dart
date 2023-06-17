import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/db/firebase_helper.dart';
import 'package:appdiphuot/util/shared_preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../model/trip.dart';
import '../../../util/log_dog_utils.dart';

class PageChatController extends BaseController {
  var conversationList = <String>[].obs;

  var trips = <Trip>[].obs;

  @override
  void onInit() {
    super.onInit();
    getTrip();
  }

  void clearOnDispose() {
    Get.delete<PageChatController>();
  }

  Future<void> getTrip() async {
    try {
      String uid = await SharedPreferencesUtil.getUIDLogin() ?? "";
      Dog.d("getTrip: userid $uid");

      var routerStream = FirebaseHelper.collectionReferenceRouter.where(
        FirebaseHelper.listIdMember,
        arrayContainsAny: [uid]
      ).snapshots();

      var routerSnapshots = routerStream.map((querySnapshot) => querySnapshot.docs);

      routerSnapshots.listen((routerSnapshots) {
        var tempTrips = <Trip>[];

        for (var routerSnapshot in routerSnapshots) {
          Dog.d("getTrip: $routerSnapshot");

          DocumentSnapshot<Map<String, dynamic>>? tripMap = routerSnapshot as DocumentSnapshot<Map<String, dynamic>>?;
          if (tripMap == null || tripMap.data() == null) return;

          var trip = Trip.fromJson(tripMap.data()!);
          tempTrips.add(trip);
        }

        trips.value = tempTrips;
        Dog.d("getTrip: $trips");

      });

    } catch (e) {
      Dog.e("getTrip: $e");
    }
  }
}
