import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/model/place.dart';
import 'package:get/get.dart';
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
}
