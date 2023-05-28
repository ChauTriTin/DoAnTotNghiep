import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/model/place.dart';
import 'package:appdiphuot/ui/home/router/map/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    required this.placeStart,
    required this.placeEnd,
    required this.listPlaceStop,
  });

  final Place placeStart;
  final Place placeEnd;
  final List<Place> listPlaceStop;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends BaseStatefulState<MapScreen> {
  final _controller = Get.put(MapController());

  @override
  void initState() {
    super.initState();
    _setupListen();
    _controller.init(widget.placeStart, widget.placeEnd, widget.listPlaceStop);
    _createMarkerImageFromAsset(context);
  }

  void _setupListen() {
    _controller.appLoading.listen((appLoading) {});
    _controller.appError.listen((err) {
      showErrorDialog(StringConstants.errorMsg, err.messageError, "Retry", () {
        //do sth
      });
    });
  }

  @override
  void dispose() {
    _controller.clearOnDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.appColorBkg,
      body: Stack(
        children: [
          _buildMapView(),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              DimenConstants.marginPaddingMedium,
              DimenConstants.marginPaddingLarge,
              DimenConstants.marginPaddingMedium,
              DimenConstants.marginPaddingMedium,
            ),
            child: FloatingActionButton(
              mini: true,
              elevation: DimenConstants.elevationMedium,
              backgroundColor: ColorConstants.appColor,
              onPressed: () {
                Get.back();
              },
              child: const Icon(Icons.clear),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return Obx(() {
      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _controller.kMapCenter.value,
          zoom: 15.0,
        ),
        markers: <Marker>{_createMarker()},
        onMapCreated: _onMapCreated,
      );
    });
  }

  Marker _createMarker() {
    if (_controller.markerIcon != null) {
      return Marker(
        markerId: const MarkerId('marker_1'),
        position: _controller.kMapCenter.value,
        icon: _controller.markerIcon!,
      );
    } else {
      return Marker(
        markerId: const MarkerId('marker_1'),
        position: _controller.kMapCenter.value,
      );
    }
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_controller.markerIcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size.square(48));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/images/ic_x.png')
          .then(_updateBitmap);
    }
  }

  void _updateBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _controller.markerIcon = bitmap;
    });
  }

  void _onMapCreated(GoogleMapController controllerParam) {
    setState(() {
      _controller.mapController = controllerParam;
    });
  }
}
