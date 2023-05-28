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
  GoogleMapController? mapController;
  BitmapDescriptor? markerIconPlaceStart;

  @override
  void initState() {
    super.initState();
    _setupListen();
    _controller.init(widget.placeStart, widget.placeEnd, widget.listPlaceStop);
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
    createMarkerPlaceStart(context);
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
          target: _controller.kMapPlaceStart.value,
          zoom: 15.0,
        ),
        markers: <Marker>{_createMarkerPlaceStart()},
        onMapCreated: _onMapCreated,
      );
    });
  }

  Marker _createMarkerPlaceStart() {
    if (markerIconPlaceStart == null) {
      return Marker(
        markerId: MarkerId(_controller.idMarkerStart),
        position: _controller.kMapPlaceStart.value,
      );
    } else {
      return Marker(
        markerId: MarkerId(_controller.idMarkerStart),
        position: _controller.kMapPlaceStart.value,
        icon: markerIconPlaceStart!,
      );
    }
  }

  void _onMapCreated(GoogleMapController controllerParam) {
    setState(() {
      mapController = controllerParam;
    });
  }

  Future<void> createMarkerPlaceStart(BuildContext context) async {
    if (markerIconPlaceStart == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size.square(55.0));
      var bitmap = await BitmapDescriptor.fromAssetImage(
        imageConfiguration,
        'assets/images/ic_x.png',
      );
      setState(() {
        markerIconPlaceStart = bitmap;
      });
    }
  }
}
