import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/model/place.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

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
      body: _buildBodyView(),
    );
  }

  Widget _buildBodyView() {
    // return MapLocationPicker(
    //   currentLatLng: LatLng(widget.defaultPlace.lat, widget.defaultPlace.long),
    //   apiKey: Constants.googleMapAPIKey,
    //   onNext: (GeocodingResult? result) {
    //     debugPrint(
    //         "MapLocationPicker onNext lat ${result?.geometry.location.lat}");
    //     debugPrint(
    //         "MapLocationPicker onNext lng ${result?.geometry.location.lng}");
    //     Get.back();
    //     Place p = Place();
    //     p.lat = result?.geometry.location.lat ?? 0.0;
    //     p.long = result?.geometry.location.lng ?? 0.0;
    //     p.name = result?.formattedAddress ?? "";
    //     widget.callback.call(p);
    //   },
    // );
    return FlutterLocationPicker(
      initZoom: 11,
      minZoomLevel: 5,
      maxZoomLevel: 16,
      trackMyPosition: true,
      onPicked: (result) {
        debugPrint("MapLocationPicker onNext lat ${result.latLong.latitude}");
        debugPrint("MapLocationPicker onNext lng ${result.latLong.longitude}");
        Get.back();
        Place p = Place();
        p.lat = result.latLong.latitude;
        p.long = result.latLong.latitude;
        p.name = result.address;
        widget.callback.call(p);
      },
    );
  }
}
