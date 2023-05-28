import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/model/place.dart';
import 'package:appdiphuot/ui/home/router/map/map_controller.dart';
import 'package:avatar_glow/avatar_glow.dart';
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
  BitmapDescriptor? markerIconPlaceEnd;

  // BitmapDescriptor? markerIconPlaceStop;
  List<BitmapDescriptor?> listMarkerIconPlaceStop = <BitmapDescriptor?>[];
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};

  @override
  void initState() {
    super.initState();
    _setupListen();
    _controller.init(widget.placeStart, widget.placeEnd, widget.listPlaceStop);
    _addPolylines();
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
    createMarker(context);
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
          _buildHelperView(),
          _buildPeopleView(),
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
        markers: _createMaker(),
        polylines: Set<Polyline>.of(polylines.values),
        onMapCreated: (controllerParam) {
          setState(() {
            mapController = controllerParam;
          });
        },
      );
    });
  }

  Set<Marker> _createMaker() {
    Marker createMarkerPlaceStart() {
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

    Marker createMarkerPlaceEnd() {
      if (markerIconPlaceEnd == null) {
        return Marker(
          markerId: MarkerId(_controller.idMarkerEnd),
          position: _controller.kMapPlaceEnd.value,
        );
      } else {
        return Marker(
          markerId: MarkerId(_controller.idMarkerEnd),
          position: _controller.kMapPlaceEnd.value,
          icon: markerIconPlaceEnd!,
        );
      }
    }

    List<Marker> createMarkerPlaceStop() {
      Marker create(int index, String markerId, LatLng position) {
        var markerIconPlaceStop = listMarkerIconPlaceStop[index];
        if (markerIconPlaceStop == null) {
          return Marker(
            markerId: MarkerId(markerId),
            position: position,
          );
        } else {
          return Marker(
            markerId: MarkerId(markerId),
            position: position,
            icon: markerIconPlaceStop,
          );
        }
      }

      var list = <Marker>[];
      for (int i = 0; i < _controller.listPlaceStop.length; i++) {
        var placeStop = _controller.listPlaceStop[i];
        var marker = create(
          i,
          _controller.getIdMarkerStop(i),
          LatLng(placeStop.lat, placeStop.long),
        );
        list.add(marker);
      }
      return list;
    }

    var list = <Marker>[];
    list.add(createMarkerPlaceStart());
    var listStop = createMarkerPlaceStop();
    for (var element in listStop) {
      list.add(element);
    }
    list.add(createMarkerPlaceEnd());
    debugPrint(">>>>_createMaker listStop.length ${listStop.length}");
    debugPrint(">>>>_createMaker list.length ${list.length}");
    return list.toSet();
  }

  void createMarker(BuildContext context) {
    Future<void> createMarkerPlaceStart(BuildContext context) async {
      if (markerIconPlaceStart == null) {
        final ImageConfiguration imageConfiguration =
            createLocalImageConfiguration(context,
                size: const Size.square(55.0));
        var bitmap = await BitmapDescriptor.fromAssetImage(
          imageConfiguration,
          'assets/images/ic_marker_start.png',
        );
        setState(() {
          markerIconPlaceStart = bitmap;
        });
      }
    }

    Future<void> createMarkerPlaceEnd(BuildContext context) async {
      if (markerIconPlaceEnd == null) {
        final ImageConfiguration imageConfiguration =
            createLocalImageConfiguration(context,
                size: const Size.square(55.0));
        var bitmap = await BitmapDescriptor.fromAssetImage(
          imageConfiguration,
          'assets/images/ic_marker_end.png',
        );
        setState(() {
          markerIconPlaceEnd = bitmap;
        });
      }
    }

    Future<void> createMarkerPlaceStop(BuildContext context) async {
      Future<BitmapDescriptor> create() async {
        final ImageConfiguration imageConfiguration =
            createLocalImageConfiguration(context,
                size: const Size.square(55.0));
        var bitmap = await BitmapDescriptor.fromAssetImage(
          imageConfiguration,
          'assets/images/ic_marker_stop.png',
        );
        return bitmap;
      }

      for (var element in _controller.listPlaceStop) {
        debugPrint(">>>createMarkerPlaceStop element ${element.name}");
        var bmp = await create();
        listMarkerIconPlaceStop.add(bmp);
      }

      setState(() {
        listMarkerIconPlaceStop;
      });
    }

    createMarkerPlaceStart(context);
    createMarkerPlaceEnd(context);
    createMarkerPlaceStop(context);
  }

  void _addPolylines() {
    final PolylineId polylineId = PolylineId(_controller.polylineId);
    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: false,
      color: ColorConstants.appColor,
      width: 5,
      // jointType: JointType.round,
      points: _controller.createPoints(),
      onTap: () {},
    );
    setState(() {
      polylines[polylineId] = polyline;
    });
  }

  Widget _buildHelperView() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: DimenConstants.marginPaddingMedium),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            elevation: DimenConstants.elevationMedium,
            backgroundColor: ColorConstants.appColor,
            onPressed: () {
              showSnackBarFull(StringConstants.warning, "TODO");
            },
            child: const Icon(Icons.pan_tool),
          ),
          const SizedBox(height: DimenConstants.marginPaddingMedium),
          FloatingActionButton(
            elevation: DimenConstants.elevationMedium,
            backgroundColor: ColorConstants.appColor,
            onPressed: () {
              showSnackBarFull(StringConstants.warning, "TODO");
            },
            child: const Icon(Icons.sms),
          ),
          const SizedBox(height: DimenConstants.marginPaddingMedium),
          FloatingActionButton(
            elevation: DimenConstants.elevationMedium,
            backgroundColor: ColorConstants.appColor,
            onPressed: () {
              showSnackBarFull(StringConstants.warning, "TODO");
            },
            child: const Icon(Icons.priority_high),
          ),
        ],
      ),
    );
  }

  Widget _buildPeopleView() {
    Widget buildItem(int pos) {
      return SizedBox(
        width: 90,
        height: 90,
        child: AvatarGlow(
          glowColor: Colors.red,
          endRadius: 60,
          duration: const Duration(milliseconds: 2000),
          repeat: true,
          showTwoGlows: true,
          repeatPauseDuration: const Duration(milliseconds: 100),
          child: SizedBox(
            width: 70,
            height: 70,
            child: ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(48), // Image radius
                child: Image.network(
                  pos % 2 == 0
                      ? "https://kenh14cdn.com/thumb_w/620/203336854389633024/2022/11/6/photo-4-16677111180281863259936.jpg"
                      : "https://kenh14cdn.com/thumb_w/620/2019/11/30/0d19c07b6b3b8265db2a-15751098043831840905821.jpg",
                  height: 45,
                  width: 45,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      // padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
      alignment: Alignment.bottomLeft,
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: 15,
          itemBuilder: (context, i) {
            return buildItem(i);
          },
        ),
      ),
    );
  }
}
