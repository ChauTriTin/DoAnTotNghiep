import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/constants.dart';
import 'package:appdiphuot/model/place.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

import '../../../../common/const/dimen_constants.dart';

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
      floatingActionButton: Visibility(
        visible: kDebugMode,
        child: FloatingActionButton(
          elevation: DimenConstants.elevationMedium,
          backgroundColor: ColorConstants.appColor,
          onPressed: () {
            widget.callback.call(Place.getRandomPlace());
            Get.back();
          },
          child: const Icon(Icons.place),
        ),
      ),
    );
  }

  Widget _buildBodyView() {
    var useCurrentLocation = widget.defaultPlace?.isDefaultPlace();
    return PlacePicker(
      apiKey: Constants.iLoveYou(),
      onPlacePicked: (result) {
        Place p = Place();
        p.lat = result.geometry?.location.lat ?? defaultLat;
        p.long = result.geometry?.location.lng ?? defaultLong;

        // p.name = result.formattedAddress ?? "";
        // debugPrint("onPlacePicked formattedAddress ${result.formattedAddress}");

        // debugPrint("onPlacePicked name ${result.name}");
        // debugPrint("onPlacePicked adrAddress ${result.adrAddress}");
        // debugPrint("onPlacePicked addressComponents length ${result.addressComponents?.length}");
        // debugPrint("onPlacePicked addressComponents ${result.addressComponents?.firstOrNull?.longName}");
        var address = "";
        result.addressComponents?.forEach((element) {
          var name = element.longName;
          debugPrint("onPlacePicked name $name");
          if (name.contains("+")) {
            //do nothing
          } else {
            address += "${element.longName}, ";
          }
        });
        address = address.trim();
        if (address.isNotEmpty) {
          address = address.substring(0, address.length - 1);
        }
        debugPrint("onPlacePicked address $address");
        p.name = address;
        // debugPrint("onPlacePicked vicinity ${result.vicinity}");

        widget.callback.call(p);
        Get.back();
      },
      initialPosition: LatLng(
        widget.defaultPlace?.lat ?? defaultLat,
        widget.defaultPlace?.long ?? defaultLong,
      ),
      useCurrentLocation: useCurrentLocation,
      resizeToAvoidBottomInset: false,
      zoomControlsEnabled: true,
      searchForInitialValue: true,
    );
  }
}
