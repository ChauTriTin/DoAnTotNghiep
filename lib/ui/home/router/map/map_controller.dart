import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/db/firebase_helper.dart';
import 'package:appdiphuot/model/place.dart';
import 'package:appdiphuot/model/user.dart';
import 'package:appdiphuot/util/shared_preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fcm_wrapper/flutter_fcm_wrapper.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_directions/google_maps_directions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends BaseController {
  void log(String s) {
    debugPrint("MapController $s");
  }

  var userData = UserData().obs;
  final polylineId = "polylineId";
  final idMarkerStart = "idMarkerStart";
  final idMarkerEnd = "idMarkerEnd";
  var kMapPlaceStart = const LatLng(Place.defaultLat, Place.defaultLong).obs;
  var kMapPlaceEnd = const LatLng(Place.defaultLat, Place.defaultLong).obs;

  var placeStart = Place().obs;
  var placeEnd = Place().obs;
  var listPlaceStop = <Place>[].obs;

  var polylines = <Polyline>[].obs;

  void clearOnDispose() {
    Get.delete<MapController>();
  }

  void init(
    Place pStart,
    Place pEnd,
    List<Place> list,
  ) {
    placeStart.value = pStart;
    placeEnd.value = pEnd;
    listPlaceStop.clear();
    listPlaceStop.addAll(list);
    listPlaceStop.refresh();

    kMapPlaceStart.value = LatLng(
        pStart.lat ?? Place.defaultLat, pStart.long ?? Place.defaultLong);
    kMapPlaceEnd.value =
        LatLng(pEnd.lat ?? Place.defaultLat, pEnd.long ?? Place.defaultLong);

    _genRouter();
    //TODO loitp
    // _genDistance();
    // _genDuration();
  }

  String getName() {
    return userData.value.name ?? "";
  }

  String getAvatar() {
    String avatarUrl = userData.value.avatar ?? "";
    if (avatarUrl.isEmpty) {
      return StringConstants.avatarImgDefault;
    } else {
      return avatarUrl;
    }
  }

  Future<void> getUserInfo() async {
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
        userData.value = user;
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
    points.add(LatLng(placeStart.value.lat ?? Place.defaultLat,
        placeStart.value.long ?? Place.defaultLong));
    for (var element in listPlaceStop) {
      points.add(LatLng(
          element.lat ?? Place.defaultLat, element.long ?? Place.defaultLong));
    }
    points.add(LatLng(placeEnd.value.lat ?? Place.defaultLat,
        placeEnd.value.long ?? Place.defaultLong));
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
            eCurrent.lat ?? Place.defaultLat,
            eCurrent.long ?? Place.defaultLong,
            eNext.lat ?? Place.defaultLat,
            eNext.long ?? Place.defaultLong);
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
        title: "Thông báo khẩn cấp từ ${getName()}",
        body: body,
        androidChannelID: DateTime.now().microsecondsSinceEpoch.toString(),
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      );
      debugPrint("FCM sendTopicMessage result $result");
    } catch (e) {
      debugPrint("FCM sendTopicMessage $e");
    }
  }
}
