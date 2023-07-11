import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/model/bus/event_bus.dart';
import 'package:appdiphuot/model/notification_data.dart';
import 'package:appdiphuot/model/place.dart';
import 'package:appdiphuot/model/user.dart';
import 'package:appdiphuot/ui/home/router/map/map_controller.dart';
import 'package:appdiphuot/ui/home/router/rate/done_trip/rate_screen.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_directions/google_maps_directions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../chat/detail/page_detail_chat_screen.dart';
import 'marker_icon.dart';

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
  final double zoomLevel = 16.0;
  StreamSubscription? eventBusOnRateSuccess;

  @override
  void initState() {
    super.initState();
    GoogleMapsDirections.init(googleAPIKey: Constants.iLoveYou());
    _setupListen();
    _listenBus();
    _controller.getRouter(widget.id);
  }

  void _setupListen() {
    _controller.appLoading.listen((appLoading) {});
    _controller.appError.listen((err) {
      showErrorDialog(StringConstants.errorMsg, err.messageError, "Retry", () {
        //do sth
      });
    });
  }

  void _listenBus() {
    eventBusOnRateSuccess = eventBus.on<OnRateSuccess>().listen((event) {
      if (event.className == mainScreen) {
        debugPrint("FCM main _listenBus mainScreen");
        Navigator.pop(context);
        debugPrint("FCM main _listenBus mainScreen pop");
      }
    });
  }

  @override
  void dispose() {
    _controller.clearOnDispose();
    eventBusOnRateSuccess?.cancel();
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
      // var listMember = _controller.listMember;

      if (trip.id == null ||
              trip.id?.isEmpty == true ||
              currentUserData.uid == null ||
              currentUserData.uid?.isEmpty == true
          // || listMember.isEmpty
          ) {
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
          zoom: zoomLevel,
        ),
        // zoomControlsEnabled: true,
        // zoomGesturesEnabled: true,
        markers: _controller.listMarkerGoogleMap.toSet(),
        polylines: Set.of(_controller.polylines),
        myLocationEnabled: false,
        compassEnabled: false,
        onMapCreated: (controllerParam) {
          debugPrint(">>>onMapCreated");
          setState(() {
            mapController = controllerParam;
            _controller.getLocation((location) {
              debugPrint(">>>getLocation $location");
              _moveCamera(location);
            });
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

  var timeCreateMaker = 0;

  void _createMaker() {
    if (timeCreateMaker != 0 &&
        DateTime.now().millisecondsSinceEpoch - timeCreateMaker < 5000) {
      //5s
      debugPrint("_createMaker !updateUI -> return");
      return;
    }
    timeCreateMaker = DateTime.now().millisecondsSinceEpoch;
    debugPrint("_createMaker updateUI");

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
        'assets/images/ic_marker_end.png',
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
          'assets/images/ic_marker_stop.png',
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

    void createMarkerMember() {
      Future<Marker> create(
        int index,
        String avt,
        String markerId,
        LatLng position,
      ) async {
        return Marker(
          icon: await MarkerIcon.downloadResizePictureCircle(
            avt,
            size: 100,
            addBorder: true,
            borderColor: ColorConstants.appColor,
            borderSize: 5,
          ),
          markerId: MarkerId(markerId),
          // markerId: MarkerId(lastMapPositionPoints.toString()),
          position: position,
        );

        // var request = await http.get(Uri.parse(avt));
        // var bytes = request.bodyBytes;
        // LatLng lastMapPositionPoints = LatLng(defaultLat, defaultLong);
        // var b = await getBytesFromCanvas(46, 46, bytes.buffer.asUint8List());
        // if (b == null) {
        //   return Marker(
        //     // markerId: MarkerId(lastMapPositionPoints.toString()),
        //     markerId: MarkerId(markerId),
        //     position: lastMapPositionPoints,
        //   );
        // }
        // return Marker(
        //   icon: BitmapDescriptor.fromBytes(b),
        //   markerId: MarkerId(markerId),
        //   // markerId: MarkerId(lastMapPositionPoints.toString()),
        //   position: position,
        // );
      }

      var listMember = _controller.listMember;
      debugPrint(
          ">>>createMarkerMember listMember length ${listMember.length}");
      for (int i = 0; i < listMember.length; i++) {
        var member = listMember[i];
        debugPrint(
            ">>>createMarkerMember createMarkerMember i $i -> ${member.name}, ${member.uid}");
        var marker = create(
          i,
          member.getAvatar(),
          "$i${member.uid}",
          LatLng(member.lat ?? defaultLat, member.long ?? defaultLong),
        );
        marker.then((value) {
          debugPrint(
              ">>>createMarkerMember then ${value.markerId} -> ${member.name}");
          _controller.setMarkerGoogleMap(value);
        });
      }
    }

    //update maker start
    var listMarketPlaceStart = createMarkerPlaceStart();
    listMarketPlaceStart.then((value) {
      _controller.setMarkerGoogleMap(value);
    });

    //update maker end
    var listMarketPlaceEnd = createMarkerPlaceEnd();
    listMarketPlaceEnd.then((value) {
      _controller.setMarkerGoogleMap(value);
    });

    //update maker stop
    createMarkerPlaceStop();

    //update maker member
    createMarkerMember();

    debugPrint(">>>>_createMaker success");
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
              Get.to(() => PageDetailChatScreen(
                  tripID: _controller.trip.value.id ?? ""));
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
          const SizedBox(height: DimenConstants.marginPaddingMedium),
          FloatingActionButton(
            heroTag: "priority_high",
            elevation: DimenConstants.elevationMedium,
            backgroundColor: ColorConstants.appColor,
            onPressed: () {
              if (_controller.iAmLeader()) {
                _controller.completeTrip();
                Get.to(RateScreen(
                  id: widget.id,
                  onRateSuccess: () {
                    Get.back(); //close this screen when rate successfully
                  },
                ));
              } else {
                showSnackBarFull(StringConstants.warning,
                    'Chỉ có Leader mới được phép hoàn tất chuyến đi');
              }
            },
            child: const Icon(Icons.rate_review),
          ),
        ],
      ),
    );
  }

  void _moveCamera(LatLng latLng) {
    mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, zoomLevel));
  }

  Widget _buildPeopleView() {
    Widget buildItem(UserData userData) {
      return InkWell(
        onTap: () {
          var lat = userData.lat;
          var long = userData.long;
          if (lat != null && long != null) {
            _moveCamera(LatLng(lat, long));
          }
        },
        child: SizedBox(
          width: 60,
          height: 60,
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
                  width: 50,
                  height: 50,
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
                padding:
                    const EdgeInsets.all(DimenConstants.marginPaddingMedium),
                child: Text(
                  userData.name ?? "",
                  style: const TextStyle(
                    fontSize: DimenConstants.txtSmall,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // if (kDebugMode)
              //   Container(
              //     color: Colors.red,
              //     child: Text(
              //       "${userData.lat}-${userData.long}",
              //       style: const TextStyle(
              //         fontSize: DimenConstants.txtTiny,
              //         color: Colors.white,
              //       ),
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
            ],
          ),
        ),
      );
    }

    return Obx(() {
      var listMember = _controller.listMember;
      if (listMember.isEmpty) {
        return Container();
      }

      // debugPrint(">>>_buildPeopleView update position marker");
      // _createMaker(true);

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
            height: Get.height * 0.8,
            padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
            child: ListView(
              children: [
                const SizedBox(height: 12),
                const Text(
                  "Cần giúp đỡ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: DimenConstants.txtHeader1,
                    color: ColorConstants.appColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 18),
                InkWell(
                  onTap: () {
                    Get.back(); //close this sheet
                    _controller.postFCM("Xe tôi hư", NotificationData.TYPE_MAP);
                  },
                  child: Card(
                      shape: UIUtils.getCardCorner(),
                      color: Color(0xFFFDD5BA),
                      shadowColor: Colors.grey,
                      elevation: DimenConstants.cardElevation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Xe tôi hư',
                              style: TextStyle(
                                fontSize: DimenConstants.txtMedium,
                                color: Color(0xFF341502),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                                width: 46,
                                height: 46,
                                child: Image.asset(
                                    "assets/images/broken_motorbike.png")),
                          ],
                        ),
                      )),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () {
                    Get.back(); //close this sheet
                    _controller.postFCM(
                        "Tôi lạc đường", NotificationData.TYPE_MAP);
                  },
                  child: Card(
                      shape: UIUtils.getCardCorner(),
                      color: Color(0xFFFAF1CB),
                      shadowColor: Colors.grey,
                      elevation: DimenConstants.cardElevation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Tôi lạc đường',
                              style: TextStyle(
                                fontSize: DimenConstants.txtMedium,
                                color: Color(0xFF772101),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                                width: 46,
                                height: 46,
                                child:
                                    Image.asset("assets/images/lost_road.png")),
                          ],
                        ),
                      )),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () {
                    Get.back(); //close this sheet
                    _controller.postFCM(
                        "Tôi muốn dừng chân", NotificationData.TYPE_MAP);
                  },
                  child: Card(
                      shape: UIUtils.getCardCorner(),
                      color: Color(0xFFE1FCCF),
                      shadowColor: Colors.grey,
                      elevation: DimenConstants.cardElevation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Tôi muốn dừng chân',
                              style: TextStyle(
                                fontSize: DimenConstants.txtMedium,
                                color: Color(0xFF1B3D01),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                                width: 46,
                                height: 46,
                                child:
                                    Image.asset("assets/images/wana_stop.png")),
                          ],
                        ),
                      )),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () {
                    Get.back(); //close this sheet
                    _controller.postFCM(
                        "Tôi gặp trục trặc", NotificationData.TYPE_MAP);
                  },
                  child: Card(
                      shape: UIUtils.getCardCorner(),
                      color: Color(0xFFD6E2FF),
                      shadowColor: Colors.grey,
                      elevation: DimenConstants.cardElevation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Tôi gặp trục trặc',
                              style: TextStyle(
                                fontSize: DimenConstants.txtMedium,
                                color: Color(0xFF003CAD),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                                width: 46,
                                height: 46,
                                child:
                                    Image.asset("assets/images/problem.png")),
                          ],
                        ),
                      )),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () {
                    Get.back(); //close this sheet
                    _controller.postFCM(
                        "Cần người giúp khẩn cấp", NotificationData.TYPE_MAP);
                  },
                  child: Card(
                      shape: UIUtils.getCardCorner(),
                      color: Color(0xFFFFD7D7),
                      shadowColor: Colors.grey,
                      elevation: DimenConstants.cardElevation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Cần người giúp khẩn cấp',
                              style: TextStyle(
                                fontSize: DimenConstants.txtMedium,
                                color: Color(0xFFCD0D0F),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                                width: 46,
                                height: 46,
                                child: Image.asset("assets/images/sos.png")),
                          ],
                        ),
                      )),
                ),
                const SizedBox(height: 16),
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
            alignment: Alignment.center,
            width: Get.width,
            height: Get.height * 0.8,
            padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
            child: ListView(
              children: [
                const SizedBox(height: 15),
                const Text(
                  "Cảnh báo",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: DimenConstants.txtHeader1,
                    color: ColorConstants.appColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () {
                    Get.back(); //close this sheet
                    _controller.postFCM(
                        "Có cảnh sát", NotificationData.TYPE_MAP);
                  },
                  child: Card(
                      shape: UIUtils.getCardCorner(),
                      color: const Color(0xFFE7EFFF),
                      shadowColor: Colors.grey,
                      elevation: DimenConstants.cardElevation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Có cảnh sát',
                              style: TextStyle(
                                fontSize: DimenConstants.txtMedium,
                                color: Color(0xFF001FB7),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                                width: 46,
                                height: 46,
                                child:
                                    Image.asset("assets/images/policeman.png")),
                          ],
                        ),
                      )),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () {
                    Get.back(); //close this sheet
                    _controller.postFCM("Đường xấu", NotificationData.TYPE_MAP);
                  },
                  child: Card(
                      shape: UIUtils.getCardCorner(),
                      color: const Color(0xFFEAF8E2),
                      shadowColor: Colors.grey,
                      elevation: DimenConstants.cardElevation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Đường xấu',
                              style: TextStyle(
                                fontSize: DimenConstants.txtMedium,
                                color: Color(0xFF154D08),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                                width: 46,
                                height: 46,
                                child: Image.asset("assets/images/road.png")),
                          ],
                        ),
                      )),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () {
                    Get.back(); //close this sheet
                    _controller.postFCM(
                        "Sắp có mưa", NotificationData.TYPE_MAP);
                  },
                  child: Card(
                      shape: UIUtils.getCardCorner(),
                      color: const Color(0xFFEFEFEF),
                      shadowColor: Colors.grey,
                      elevation: DimenConstants.cardElevation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Sắp có mưa",
                              style: TextStyle(
                                fontSize: DimenConstants.txtMedium,
                                color: Color(0xFF2A2A2A),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                                width: 46,
                                height: 46,
                                child: Image.asset("assets/images/rain.png")),
                          ],
                        ),
                      )),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () {
                    Get.back(); //close this sheet
                    _controller.postFCM(
                        "Giữ khoảng cách", NotificationData.TYPE_MAP);
                  },
                  child: Card(
                      shape: UIUtils.getCardCorner(),
                      color: const Color(0xFFFFE7D9),
                      shadowColor: Colors.grey,
                      elevation: DimenConstants.cardElevation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Giữ khoảng cách",
                              style: TextStyle(
                                fontSize: DimenConstants.txtMedium,
                                color: Color(0xFFB67D10),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                                width: 46,
                                height: 46,
                                child:
                                    Image.asset("assets/images/distance.png")),
                          ],
                        ),
                      )),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () {
                    Get.back(); //close this sheet
                    _controller.postFCM(
                        "Dừng khẩn cấp", NotificationData.TYPE_MAP);
                  },
                  child: Card(
                      shape: UIUtils.getCardCorner(),
                      color: const Color(0xFFFFD9DA),
                      shadowColor: Colors.grey,
                      elevation: DimenConstants.cardElevation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Dừng khẩn cấp",
                              style: TextStyle(
                                fontSize: DimenConstants.txtMedium,
                                color: Color(0xFFA80000),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                                width: 46,
                                height: 46,
                                child: Image.asset("assets/images/stop.png")),
                          ],
                        ),
                      )),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
