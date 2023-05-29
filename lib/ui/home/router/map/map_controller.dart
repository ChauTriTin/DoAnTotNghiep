import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/model/place.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_directions/google_maps_directions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_directions/google_maps_directions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends BaseController {
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

    kMapPlaceStart.value = LatLng(pStart.lat, pStart.long);
    kMapPlaceEnd.value = LatLng(pEnd.lat, pEnd.long);

    getRoute(pStart.lat, pStart.long, pEnd.lat, pEnd.long);
  }

  String getIdMarkerStop(int position) {
    return "idMarkerStop$position";
  }

  List<LatLng> createPoints() {
    final List<LatLng> points = <LatLng>[];
    points.add(LatLng(placeStart.value.lat, placeStart.value.long));
    for (var element in listPlaceStop) {
      points.add(LatLng(element.lat, element.long));
    }
    points.add(LatLng(placeEnd.value.lat, placeEnd.value.long));
    return points;
  }

  Future<void> getRoute(
    double lat1,
    double long1,
    double lat2,
    double long2,
  ) async {
    debugPrint("<<<route $lat1 $long1, $lat2 $long2");
    Directions directions = await getDirections(
      lat1,
      long1,
      lat2,
      long2,
    );

    DirectionRoute route = directions.shortestRoute;
    debugPrint(">>>route done");
    List<LatLng> points = PolylinePoints()
        .decodePolyline(route.overviewPolyline.points)
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
    debugPrint(">>>decodePolyline ${points.length}");
    List<Polyline> listPolyline = [
      Polyline(
        width: 5,
        polylineId: const PolylineId("111"),
        color: ColorConstants.appColor,
        points: points,
      ),
    ];
    polylines.addAll(listPolyline);
    polylines.refresh();
  }
}
