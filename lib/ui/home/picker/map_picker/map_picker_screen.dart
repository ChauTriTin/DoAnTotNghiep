import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/constants.dart';
import 'package:flutter/material.dart';
import 'package:map_location_picker/map_location_picker.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({
    super.key,
  });

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends BaseStatefulState<MapPickerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.appColorBkg,
      body: MapLocationPicker(
        apiKey: Constants.googleMapAPIKey,
        onNext: (GeocodingResult? result) {
          debugPrint(
              "MapLocationPicker onNext lat ${result?.geometry.location.lat}");
          debugPrint(
              "MapLocationPicker onNext lng ${result?.geometry.location.lng}");
        },
      ),
    );
  }
}
