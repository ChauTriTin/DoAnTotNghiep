import 'dart:async';
import 'dart:ui' as ui;

import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/model/place.dart';
import 'package:appdiphuot/model/user.dart';
import 'package:appdiphuot/ui/home/router/map/map_controller.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_directions/google_maps_directions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
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

  @override
  void initState() {
    super.initState();
    GoogleMapsDirections.init(googleAPIKey: Constants.iLoveYou());
    _setupListen();
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
      var trip = _controller.trip.value;
      var currentUserData = _controller.currentUserData.value;
      var listMember = _controller.listMember;

      if (trip.id == null ||
          trip.id?.isEmpty == true ||
          currentUserData.uid == null ||
          currentUserData.uid?.isEmpty == true ||
          listMember.isEmpty) {
        return Container(
          width: Get.width,
          height: Get.height,
          color: ColorConstants.appColorBkg,
          child: const Center(
            child: CupertinoActivityIndicator(
              radius: 20.0,
              color: ColorConstants.appColor,
            ),
          ),
        );
      }
      _createMaker();
      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _controller.kMapPlaceStart.value,
          zoom: 15.0,
        ),
        markers: _controller.listMarkerGoogleMap.toSet(),
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

  Future<Uint8List?> getBytesFromCanvas(
      int width, int height, Uint8List dataBytes) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.transparent;
    const Radius radius = Radius.circular(20.0);
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);

    var imaged = await loadImage(dataBytes.buffer.asUint8List());
    canvas.drawImageRect(
      imaged,
      Rect.fromLTRB(
          0.0, 0.0, imaged.width.toDouble(), imaged.height.toDouble()),
      Rect.fromLTRB(0.0, 0.0, width.toDouble(), height.toDouble()),
      Paint(),
    );

    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data?.buffer.asUint8List();
  }

  Future<ui.Image> loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  void _createMaker() {
    Future<Marker> createMarkerPlaceStart() async {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size.square(55.0));
      var bitmap = await BitmapDescriptor.fromAssetImage(
        imageConfiguration,
        'assets/images/ic_marker_start.png',
      );
      return Marker(
        markerId: MarkerId(_controller.idMarkerStart),
        position: _controller.kMapPlaceStart.value,
        icon: bitmap,
      );
    }

    Future<Marker> createMarkerPlaceEnd() async {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size.square(55.0));
      var bitmap = await BitmapDescriptor.fromAssetImage(
        imageConfiguration,
        'assets/images/ic_marker_start.png',
      );
      return Marker(
        markerId: MarkerId(_controller.idMarkerEnd),
        position: _controller.kMapPlaceEnd.value,
        icon: bitmap,
      );
    }

    void createMarkerPlaceStop() {
      Future<Marker> create(int index, String markerId, LatLng position) async {
        ImageConfiguration imageConfiguration = createLocalImageConfiguration(
            context,
            size: const Size.square(55.0));
        var bitmap = await BitmapDescriptor.fromAssetImage(
          imageConfiguration,
          'assets/images/ic_marker_start.png',
        );
        return Marker(
          markerId: MarkerId(markerId),
          position: position,
          icon: bitmap,
        );
      }

      for (int i = 0; i < _controller.listPlaceStop.length; i++) {
        var placeStop = _controller.listPlaceStop[i];
        var marker = create(
          i,
          _controller.getIdMarkerStop(i),
          LatLng(placeStop.lat ?? defaultLat, placeStop.long ?? defaultLong),
        );
        marker.then((value) {
          _controller.setMarkerGoogleMap(value);
        });
      }
    }
    // debugPrint(">>>>_createMaker listStop.length ${listStop.length}");

    createMarkerMember() {
      Future<Marker> create(
        int index,
        String avt,
        String markerId,
        LatLng position,
      ) async {
        var request = await http.get(Uri.parse(avt));
        var bytes = request.bodyBytes;
        LatLng lastMapPositionPoints = LatLng(defaultLat, defaultLong);
        var b = await getBytesFromCanvas(150, 150, bytes.buffer.asUint8List());
        if (b == null) {
          return Marker(
            markerId: MarkerId(lastMapPositionPoints.toString()),
            position: lastMapPositionPoints,
          );
        }
        return Marker(
          icon: BitmapDescriptor.fromBytes(b),
          markerId: MarkerId(lastMapPositionPoints.toString()),
          position: lastMapPositionPoints,
        );
      }

      var listMember = _controller.listMember;
      debugPrint(">>>_createMaker listMember length ${listMember.length}");
      for (int i = 0; i < listMember.length; i++) {
        var member = listMember[i];
        debugPrint(">>>_createMaker createMarkerMember i $i -> ${member.name}");
        var marker = create(
          i,
          member.getAvatar(),
          "$i${member.uid}",
          LatLng(member.lat ?? defaultLat, member.long ?? defaultLong),
        );
        marker.then((value) {
          _controller.setMarkerGoogleMap(value);
        });
      }
    }

    var listMarketPlaceStart = createMarkerPlaceStart();
    listMarketPlaceStart.then((value) {
      _controller.setMarkerGoogleMap(value);
    });

    var listMarketPlaceEnd = createMarkerPlaceEnd();
    listMarketPlaceEnd.then((value) {
      _controller.setMarkerGoogleMap(value);
    });

    createMarkerPlaceStop();

    createMarkerMember();
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
                      userData.getAvatar(),
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
            if (kDebugMode)
              Container(
                color: Colors.red,
                child: Text(
                  "${userData.lat}-${userData.long}",
                  style: const TextStyle(
                    fontSize: DimenConstants.txtTiny,
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

      //TODO update position marker
      // _createMaker();

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
