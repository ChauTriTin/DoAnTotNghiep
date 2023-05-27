import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/constants.dart';
import 'package:appdiphuot/model/place.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({
    super.key,
    required this.defaultPlace,
    required this.callback,
  });

  final Place? defaultPlace;
  final Function(Place newPlace) callback;

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends BaseStatefulState<MapPickerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.appColorBkg,
      body: _buildBodyView(),
    );
  }

  Widget _buildBodyView() {
    var useCurrentLocation = widget.defaultPlace?.isDefaultPlace();
    return PlacePicker(
      apiKey: Constants.googleMapAPIKey,
      onPlacePicked: (result) {
        Place p = Place();
        p.lat = result.geometry?.location.lat ?? Place.defaultLat;
        p.long = result.geometry?.location.lng ?? Place.defaultLong;
        p.name = result.formattedAddress ?? "";
        widget.callback.call(p);
        Get.back();
      },
      initialPosition: LatLng(
        widget.defaultPlace?.lat ?? Place.defaultLat,
        widget.defaultPlace?.long ?? Place.defaultLong,
      ),
      useCurrentLocation: useCurrentLocation,
      resizeToAvoidBottomInset: false,
      zoomControlsEnabled: true,
    );
  }
}