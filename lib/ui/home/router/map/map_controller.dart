import 'dart:async';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/db/firebase_helper.dart';
import 'package:appdiphuot/model/place.dart';
import 'package:appdiphuot/model/trip.dart';
import 'package:appdiphuot/model/user.dart';
import 'package:appdiphuot/util/shared_preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fcm_wrapper/flutter_fcm_wrapper.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_directions/google_maps_directions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends BaseController {
  void log(String s) {
    debugPrint("MapController $s");
  }

  var trip = Trip().obs;
  var currentUserData = UserData().obs;
  var listMember = <UserData>[].obs;

  var isGenDoneMarkerIconPlaceStart = false.obs;
  var isGenDoneMarkerIconPlaceEnd = false.obs;
  var isGenDoneListMarkerIconPlaceStop = false.obs;
  var isGenDoneListMarkerMember = false.obs;
  var isGenAllMarkerDone = false.obs;

  var listMarkerGoogleMap = <Marker>[].obs;

  final polylineId = "polylineId";
  final idMarkerStart = "idMarkerStart";
  final idMarkerEnd = "idMarkerEnd";
  var kMapPlaceStart = LatLng(defaultLat, defaultLong).obs;
  var kMapPlaceEnd = LatLng(defaultLat, defaultLong).obs;

  var placeStart = Place().obs;
  var placeEnd = Place().obs;
  var listPlaceStop = <Place>[].obs;

  var polylines = <Polyline>[].obs;
  Timer? timer;

  void clearOnDispose() {
    timer?.cancel();
    Get.delete<MapController>();
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

        //gen list router
        var pStart = this.trip.value.placeStart;
        var pEnd = this.trip.value.placeEnd;
        var list = this.trip.value.listPlace;
        if (pStart != null && pEnd != null && list != null) {
          _initRouter(pStart, pEnd, list);
        }

        //gen list member
        _genListMember(this.trip.value.listIdMember ?? List.empty());
      });
    } catch (e) {
      debugPrint("getRouter get user info fail: $e");
    }
  }

  void _initRouter(
    Place pStart,
    Place pEnd,
    List<Place> list,
  ) {
    placeStart.value = pStart;
    placeEnd.value = pEnd;
    listPlaceStop.clear();
    listPlaceStop.addAll(list);
    listPlaceStop.refresh();

    kMapPlaceStart.value =
        LatLng(pStart.lat ?? defaultLat, pStart.long ?? defaultLong);
    kMapPlaceEnd.value =
        LatLng(pEnd.lat ?? defaultLat, pEnd.long ?? defaultLong);

    _genRouter();
    //TODO loitp
    // _genDistance();
    // _genDuration();
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

  String getCurrentUserName() {
    return currentUserData.value.name ?? "";
  }

  String getCurrentUserAvatar() {
    String avatarUrl = currentUserData.value.avatar ?? "";
    if (avatarUrl.isEmpty) {
      return StringConstants.avatarImgDefault;
    } else {
      return avatarUrl;
    }
  }

  Future<void> getCurrentUserInfo() async {
    try {
      String uid = await SharedPreferencesUtil.getUIDLogin() ?? "";
      FirebaseHelper.collectionReferenceUser
          .doc(uid)
          .snapshots()
          .listen((value) {
        DocumentSnapshot<Map<String, dynamic>>? userMap =
            value as DocumentSnapshot<Map<String, dynamic>>?;
        if (userMap == null || userMap.data() == null) return;

        var user = UserData.fromJson((userMap).data()!);
        currentUserData.value = user;
        debugPrint("getUserInfo success: ${user.toString()}");
      });
    } catch (e) {
      debugPrint("getUserInfo get user info fail: $e");
    }
  }

  String getIdMarkerStop(int position) {
    return "idMarkerStop$position";
  }

  List<LatLng> createPoints() {
    final List<LatLng> points = <LatLng>[];
    points.add(LatLng(placeStart.value.lat ?? defaultLat,
        placeStart.value.long ?? defaultLong));
    for (var element in listPlaceStop) {
      points
          .add(LatLng(element.lat ?? defaultLat, element.long ?? defaultLong));
    }
    points.add(LatLng(
        placeEnd.value.lat ?? defaultLat, placeEnd.value.long ?? defaultLong));
    return points;
  }

  Future<List<LatLng>> _getRoute(
    double lat1,
    double long1,
    double lat2,
    double long2,
  ) async {
    log("<<<_getRoute $lat1 $long1, $lat2 $long2");
    Directions directions = await getDirections(
      lat1,
      long1,
      lat2,
      long2,
    );

    DirectionRoute route = directions.shortestRoute;
    log(">>>route done");
    List<LatLng> points = PolylinePoints()
        .decodePolyline(route.overviewPolyline.points)
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
    log(">>>decodePolyline ${points.length}");
    return points;
  }

  void _genRouter() {
    polylines.clear();

    var listPlace = <Place>[];
    listPlace.add(placeStart.value);
    for (var element in listPlaceStop) {
      listPlace.add(element);
    }
    listPlace.add(placeEnd.value);
    log(">>>_genRouter listPlace ${listPlace.length}");

    for (int i = 0; i < listPlace.length; i++) {
      var listLatLong = <LatLng>[];
      try {
        log("_genRouter $i - ${i + 1}");
        var eCurrent = listPlace[i];
        var eNext = listPlace[i + 1];
        var listPolyline = _getRoute(
            eCurrent.lat ?? defaultLat,
            eCurrent.long ?? defaultLong,
            eNext.lat ?? defaultLat,
            eNext.long ?? defaultLong);
        listPolyline.then((list) {
          listLatLong.addAll(list);
          log("_genRouter listPolyline list ${list.length} -> listLatLong ${listLatLong.length}");

          List<Polyline> listPolyline = [
            Polyline(
              width: 7,
              polylineId: PolylineId("$i"),
              color: ColorConstants.getRandomColor(),
              points: listLatLong,
            ),
          ];

          polylines.addAll(listPolyline);
          polylines.refresh();
        });
      } catch (e) {
        log("_genRouter e ${e.toString()}");
      }
    }
  }

  Future<void> _genDistance() async {
    DistanceValue distanceBetween = await distance(
      9.2460524,
      1.2144565,
      6.1271617,
      1.2345417,
    );
    int meters = distanceBetween.meters;
    String textInKmOrMeters = distanceBetween.text;
    debugPrint(
        ">>>_genDistance meters $meters, textInKmOrMeters $textInKmOrMeters");
  }

  Future<void> _genDuration() async {
    DurationValue durationBetween = await duration(
      9.2460524,
      1.2144565,
      6.1271617,
      1.2345417,
    );

    int seconds = durationBetween.seconds;
    String durationInMinutesOrHours = durationBetween.text;
    debugPrint(
        ">>>_genDuration seconds $seconds, durationInMinutesOrHours $durationInMinutesOrHours");
  }

  Future<void> postFCM(
    String body,
  ) async {
    FlutterFCMWrapper flutterFCMWrapper = const FlutterFCMWrapper(
      apiKey:
          "AAAAe0-zsYY:APA91bG9bdzbaJkWI6q22l1fJq1xNKiFNy1-VabYMH0hJ4Z48-IXrvMC10LNxop3mj_dhAUzcRiIuO8TpKeHCxXGcfI1DhBmhxWyotBic9Y9brDcQLncazDztqL3dVXj7i7tKBEPXrNL",
      enableLog: true,
      enableServerRespondLog: true,
    );
    try {
      //TODO loitp
      Map<String, dynamic> result =
          await flutterFCMWrapper.sendMessageByTokenID(
        userRegistrationTokens: [
          "eBA8en3rQlmJS4Ee3JojTp:APA91bGel4ViClD5zq9Sbhosv-Pl4LCZ53jvITofajhzx7efsMpXs-Xi_1SVKP61LtYr2jqK1s9cCxZWdw32C8GQme0P-Ed9ga_khgTtM2UrpKGhc8WF6j3SUigUWpw86hN20fuYrgxh",
          "e8hPdUzASaqjB7dU0TbT7R:APA91bHQImI50Fzhr8P1NoRcYMQMpfOhX8yGn4ZWXwLDQJgWbVgb7FYjz8DjdfAEvfN0o5_EQa0bw5lBFerkeAW0ScCfEmfGya9quF5kre27EdNzgznxFrJLzkbWAqGMkg7eSjXt0KMF"
        ],
        title: "Thông báo khẩn cấp từ ${getCurrentUserName()}",
        body: body,
        androidChannelID: DateTime.now().microsecondsSinceEpoch.toString(),
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      );
      debugPrint("FCM sendTopicMessage result $result");
    } catch (e) {
      debugPrint("FCM sendTopicMessage $e");
    }
  }

  getLocation() async {
    Future<void> getLoc() async {
      debugPrint("getLocation~~~ ${DateTime.now().toIso8601String()}");
      LocationPermission permission = await Geolocator.requestPermission();
      debugPrint("getLocation permission ${permission.toString()}");

      // if (permission != LocationPermission.always ||
      //     permission != LocationPermission.whileInUse) {
      //   debugPrint("getLocation permission return");
      //   return;
      // }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double lat = position.latitude;
      double long = position.longitude;
      debugPrint("getLocation lat $lat");
      debugPrint("getLocation long $long");

      LatLng location = LatLng(lat, long);
      debugPrint("getLocation $location");

      var currentUserId = currentUserData.value.uid;
      if (currentUserId?.isNotEmpty == true) {
        FirebaseHelper.collectionReferenceUser.doc(currentUserId).update({
          "lat": lat,
          "long": long,
        });
        debugPrint(
            "getLocation collectionReferenceUser update currentUserId $currentUserId");
      }
    }

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      getLoc();
    });
  }

  void checkIsGenAllMarkerDone() {
    if (isGenDoneMarkerIconPlaceStart.value == false ||
        isGenDoneMarkerIconPlaceEnd.value == false ||
        isGenDoneListMarkerIconPlaceStop.value == false ||
        isGenDoneListMarkerMember.value == false) {
      isGenAllMarkerDone.value = false;
    }
    Timer(const Duration(seconds: 1), () {
      isGenAllMarkerDone.value = true;
    });
  }

  bool isContainMarker(Marker m) {
    for (var element in listMarkerGoogleMap) {
      if (element.mapsId == m.mapsId) {
        return true;
      }
    }
    return false;
  }

  void setMarkerGoogleMap(Marker marker) {
    if (isContainMarker(marker)) {
      //do nothing
    } else {
      listMarkerGoogleMap.add(marker);
      listMarkerGoogleMap.refresh();
    }
    debugPrint(
        "_createMaker size setMarkerGoogleMap listMarkerGoogleMap ${listMarkerGoogleMap.length}");
  }

  void setListMarkerGoogleMap(List<Marker> list) {
    for (var element in list) {
      if (isContainMarker(element)) {
        //do nothing
      } else {
        listMarkerGoogleMap.add(element);
      }
    }
    listMarkerGoogleMap.refresh();
    debugPrint(
        "_createMaker size setListMarkerGoogleMap listMarkerGoogleMap ${listMarkerGoogleMap.length}");
  }
}
