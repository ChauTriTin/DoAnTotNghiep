import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/constants.dart';
import 'package:appdiphuot/model/place.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_location_picker/map_location_picker.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({
    super.key,
    required this.defaultPlace,
    required this.callback,
  });

  final Place defaultPlace;
  final Function(Place newPlace) callback;

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends BaseStatefulState<MapPickerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.appColorBkg,
      body: MapLocationPicker(
        currentLatLng:
            LatLng(widget.defaultPlace.lat, widget.defaultPlace.long),
        apiKey: Constants.googleMapAPIKey,
        onNext: (GeocodingResult? result) {
          debugPrint(
              "MapLocationPicker onNext lat ${result?.geometry.location.lat}");
          debugPrint(
              "MapLocationPicker onNext lng ${result?.geometry.location.lng}");
          Get.back();
          Place p = Place();
          p.lat = result?.geometry.location.lat ?? 0.0;
          p.long = result?.geometry.location.lng ?? 0.0;
          p.name = result?.formattedAddress ?? "";
          widget.callback.call(p);
        },
      ),
    );
  }
}
