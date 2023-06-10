import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/model/place.dart';
import 'package:appdiphuot/model/user.dart';
import 'package:appdiphuot/ui/home/router/map/map_controller.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_directions/google_maps_directions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    required this.id,
  });
  final String id;

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

  int countCreateMarker = 0;

  @override
  void initState() {
    super.initState();
    GoogleMapsDirections.init(googleAPIKey: Constants.iLoveYou());
    _setupListen();
    _controller.getCurrentUserInfo();
    _controller.getRouter(widget.id);
    _controller.getLocation();
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
    if (countCreateMarker <= 0) {
      createMarker(context);
      countCreateMarker++;
    }
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
              heroTag: "clear",
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
        polylines: Set.of(_controller.polylines),
        myLocationEnabled: true,
        compassEnabled: true,
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
          LatLng(placeStop.lat ?? Place.defaultLat,
              placeStop.long ?? Place.defaultLong),
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

  Widget _buildHelperView() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: DimenConstants.marginPaddingMedium),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: "pan_tool",
            elevation: DimenConstants.elevationMedium,
            backgroundColor: ColorConstants.appColor,
            onPressed: () {
              _showBottomSheetSos();
            },
            child: const Icon(Icons.pan_tool),
          ),
          const SizedBox(height: DimenConstants.marginPaddingMedium),
          FloatingActionButton(
            heroTag: "sms",
            elevation: DimenConstants.elevationMedium,
            backgroundColor: ColorConstants.appColor,
            onPressed: () {
              showSnackBarFull(StringConstants.warning, "TODO");
            },
            child: const Icon(Icons.sms),
          ),
          const SizedBox(height: DimenConstants.marginPaddingMedium),
          FloatingActionButton(
            heroTag: "priority_high",
            elevation: DimenConstants.elevationMedium,
            backgroundColor: ColorConstants.appColor,
            onPressed: () {
              _showBottomSheetWarning();
            },
            child: const Icon(Icons.priority_high),
          ),
        ],
      ),
    );
  }

  Widget _buildPeopleView() {
    Widget buildItem(UserData userData) {
      return SizedBox(
        width: 90,
        height: 90,
        child: Stack(
          children: [
            AvatarGlow(
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
                      "${userData.avatar}",
                      height: 45,
                      width: 45,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
              child: Text(
                userData.name ?? "",
                style: const TextStyle(
                  fontSize: DimenConstants.txtSmall,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return Obx(() {
      var listMember = _controller.listMember;
      if (listMember.isEmpty) {
        return Container();
      }
      return Container(
        // padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
        alignment: Alignment.bottomLeft,
        child: SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: listMember.length,
            itemBuilder: (context, i) {
              return buildItem(listMember[i]);
            },
          ),
        ),
      );
    });
  }

  void _showBottomSheetSos() {
    showBarModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return Material(
          child: Container(
            width: Get.width,
            height: 420,
            padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "SOS",
                  style: TextStyle(
                    fontSize: DimenConstants.txtHeader1,
                    color: ColorConstants.appColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: DimenConstants.marginPaddingMedium),
                ElevatedButton(
                  onPressed: () {
                    Get.back(); //close this sheet
                    _controller.postFCM("Xe tôi hư");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.appColor,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(DimenConstants.radiusRound),
                    ),
                    minimumSize: Size(Get.width, 50),
                  ),
                  child: const Text(
                    'Xe tôi hư',
                    style: TextStyle(
                      fontSize: DimenConstants.txtMedium,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: DimenConstants.marginPaddingMedium),
                ElevatedButton(
                  onPressed: () {
                    Get.back(); //close this sheet
                    _controller.postFCM("Tôi lạc đường");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(DimenConstants.radiusRound),
                    ),
                    minimumSize: Size(Get.width, 50),
                  ),
                  child: const Text(
                    'Tôi lạc đường',
                    style: TextStyle(
                      fontSize: DimenConstants.txtMedium,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: DimenConstants.marginPaddingMedium),
                ElevatedButton(
                  onPressed: () {
                    Get.back(); //close this sheet
                    _controller.postFCM("Tôi muốn dừng chân");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(DimenConstants.radiusRound),
                    ),
                    minimumSize: Size(Get.width, 50),
                  ),
                  child: const Text(
                    'Tôi muốn dừng chân',
                    style: TextStyle(
                      fontSize: DimenConstants.txtMedium,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: DimenConstants.marginPaddingMedium),
                ElevatedButton(
                  onPressed: () {
                    Get.back(); //close this sheet
                    _controller.postFCM("Tôi gặp trục trặc");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(DimenConstants.radiusRound),
                    ),
                    minimumSize: Size(Get.width, 50),
                  ),
                  child: const Text(
                    'Tôi gặp trục trặc',
                    style: TextStyle(
                      fontSize: DimenConstants.txtMedium,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: DimenConstants.marginPaddingMedium),
                ElevatedButton(
                  onPressed: () {
                    Get.back(); //close this sheet
                    _controller.postFCM("Cần người giúp khẩn cấp");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(DimenConstants.radiusRound),
                    ),
                    minimumSize: Size(Get.width, 50),
                  ),
                  child: const Text(
                    'Cần người giúp khẩn cấp',
                    style: TextStyle(
                      fontSize: DimenConstants.txtMedium,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheetWarning() {
    showBarModalBottomSheet(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) {
        return Material(
          child: Container(
            width: Get.width,
            height: 420,
            padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Cảnh báo".toUpperCase(),
                  style: const TextStyle(
                    fontSize: DimenConstants.txtHeader1,
                    color: ColorConstants.appColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: DimenConstants.marginPaddingMedium),
                ElevatedButton(
                  onPressed: () {
                    Get.back(); //close this sheet
                    _controller.postFCM("Có cảnh sát");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.appColor,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(DimenConstants.radiusRound),
                    ),
                    minimumSize: Size(Get.width, 50),
                  ),
                  child: const Text(
                    'Có cảnh sát',
                    style: TextStyle(
                      fontSize: DimenConstants.txtMedium,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: DimenConstants.marginPaddingMedium),
                ElevatedButton(
                  onPressed: () {
                    Get.back(); //close this sheet
                    _controller.postFCM("Đường xấu");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(DimenConstants.radiusRound),
                    ),
                    minimumSize: Size(Get.width, 50),
                  ),
                  child: const Text(
                    'Đường xấu',
                    style: TextStyle(
                      fontSize: DimenConstants.txtMedium,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: DimenConstants.marginPaddingMedium),
                ElevatedButton(
                  onPressed: () {
                    Get.back(); //close this sheet
                    _controller.postFCM("Sắp có mưa");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(DimenConstants.radiusRound),
                    ),
                    minimumSize: Size(Get.width, 50),
                  ),
                  child: const Text(
                    'Sắp có mưa',
                    style: TextStyle(
                      fontSize: DimenConstants.txtMedium,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: DimenConstants.marginPaddingMedium),
                ElevatedButton(
                  onPressed: () {
                    Get.back(); //close this sheet
                    _controller.postFCM("Giữ khoảng cách");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(DimenConstants.radiusRound),
                    ),
                    minimumSize: Size(Get.width, 50),
                  ),
                  child: const Text(
                    'Giữ khoảng cách',
                    style: TextStyle(
                      fontSize: DimenConstants.txtMedium,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: DimenConstants.marginPaddingMedium),
                ElevatedButton(
                  onPressed: () {
                    Get.back(); //close this sheet
                    _controller.postFCM("Dừng khẩn cấp");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(DimenConstants.radiusRound),
                    ),
                    minimumSize: Size(Get.width, 50),
                  ),
                  child: const Text(
                    'Dừng khẩn cấp',
                    style: TextStyle(
                      fontSize: DimenConstants.txtMedium,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
