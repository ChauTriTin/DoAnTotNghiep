import 'dart:convert';
import 'dart:developer';

import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/home/home/detail/page_detail_router_screen.dart';
import 'package:appdiphuot/ui/home/home/page_home_controller.dart';
import 'package:appdiphuot/ui/home/router/create/create_router_screen.dart';
import 'package:appdiphuot/util/log_dog_utils.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:appdiphuot/view/state_home_widget.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../../../common/const/constants.dart';
import '../../../model/trip.dart';
import '../../../view/profile_bar_widget.dart';

class PageHomeScreen extends StatefulWidget {
  const PageHomeScreen({
    super.key,
  });

  @override
  State<PageHomeScreen> createState() => _PageHomeScreenState();
}

class _PageHomeScreenState extends BaseStatefulState<PageHomeScreen> {
  final _controller = Get.put(PageHomeController());
  final _searchController = TextEditingController();

  final List<String> itemsDropdown = [
    StringConstants.tripOpen,
    StringConstants.tripPost,
    StringConstants.tripTop,
    StringConstants.placeTop,
  ];

  String? selectedValue;

  @override
  void initState() {
    super.initState();
    _setupListen();
    _controller.getAllRouter();
  }

  @override
  void dispose() {
    _controller.clearOnDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Obx(() {
        return Container(
            color: ColorConstants.colorWhite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildBanner(), _buildSearchBox(), _buildListRouter()],
            ));
      }),
      floatingActionButton: FloatingActionButton(
        elevation: DimenConstants.elevationMedium,
        backgroundColor: ColorConstants.appColor,
        onPressed: () {
          Get.to(const CreateRouterScreen(
            dfTitle: "",
            dfDescription: "",
            dfPlaceStart: null,
            dfPlaceEnd: null,
            dfListPlaceStop: [],
            dfDateTimeStart: null,
            dfDateTimeEnd: null,
            dfRequire: "",
            dfIsPublic: true,
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.orangeAccent),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding:
                          const EdgeInsets.only(left: 24, top: 12, bottom: 8),
                      child: const Text(
                        "Sự kiện đi để nhận",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      )),
                  Container(
                    padding: const EdgeInsets.only(left: 24, bottom: 12),
                    child: const Text(
                      "Hãy tham gia sự kiên này cùng với bạn \nbè để nhận nhiều ưu đãi nhé",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
                width: 90,
                height: 90,
                child: Lottie.network(
                    "https://assets7.lottiefiles.com/packages/lf20_vuubgscl.json")),
          ],
        ),
      ),
    );
  }

  void _openFilterBottomSheet(BuildContext context) {
    Get.bottomSheet(Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(DimenConstants.borderBottomAuth),
              topRight: Radius.circular(DimenConstants.borderBottomAuth),
            )),
        child: Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Bộ lọc",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 4),
              const Divider(
                color: ColorConstants.dividerColor,
                thickness: DimenConstants.dividerHeight,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  "Loại chuyến đi",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Wrap(spacing: 8.0, children: [
                  StateHomeWidget(
                    isChoose: _controller.buttonChipTypeSelected.value ==
                        StringConstants.tripOpen,
                    icon: Icon(Icons.alarm,
                        size: 18,
                        color: _controller.buttonChipTypeSelected.value ==
                                StringConstants.tripOpen
                            ? Colors.white
                            : Colors.red),
                    text: StringConstants.tripOpen,
                    onPress: () {
                      setState(() {
                        selectedValue = StringConstants.tripOpen;
                        _controller.setTypeTrip(StringConstants.tripOpen);
                      });
                    },
                  ),
                  StateHomeWidget(
                    isChoose: _controller.buttonChipTypeSelected.value ==
                        StringConstants.tripPost,
                    icon: Icon(Icons.alarm_on_rounded,
                        size: 18,
                        color: _controller.buttonChipTypeSelected.value ==
                                StringConstants.tripPost
                            ? Colors.white
                            : Colors.red),
                    text: StringConstants.tripPost,
                    onPress: () {
                      setState(() {
                        selectedValue = StringConstants.tripPost;
                        _controller.setTypeTrip(StringConstants.tripPost);
                      });
                    },
                  ),
                  StateHomeWidget(
                    isChoose: _controller.buttonChipTypeSelected.value ==
                        StringConstants.tripTop,
                    icon: Icon(Icons.vertical_align_top,
                        size: 18,
                        color: _controller.buttonChipTypeSelected.value ==
                                StringConstants.tripTop
                            ? Colors.white
                            : Colors.red),
                    text: StringConstants.tripTop,
                    onPress: () {
                      setState(() {
                        selectedValue = StringConstants.tripTop;
                        _controller.setTypeTrip(StringConstants.tripTop);
                      });
                    },
                  ),
                  StateHomeWidget(
                    isChoose: _controller.buttonChipTypeSelected.value ==
                        StringConstants.placeTop,
                    icon: Icon(Icons.location_city,
                        size: 18,
                        color: _controller.buttonChipTypeSelected.value ==
                                StringConstants.placeTop
                            ? Colors.white
                            : Colors.red),
                    text: StringConstants.placeTop,
                    onPress: () {
                      setState(() {
                        selectedValue = StringConstants.placeTop;
                        _controller.setTypeTrip(StringConstants.placeTop);
                      });
                    },
                  ),
                ]),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Text(
                  "Trạng thái chuyến đi",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Wrap(spacing: 8.0, children: [
                  StateHomeWidget(
                    isChoose: _controller.buttonChoose.value == 0,
                    icon: Icon(Icons.done_all,
                        size: 18,
                        color: _controller.buttonChoose.value == 0
                            ? Colors.white
                            : Colors.red),
                    text: "Tất cả",
                    onPress: () {
                      setState(() {
                        _searchController.clear();
                        _controller.setButtonChoose(0);
                      });
                    },
                  ),
                  StateHomeWidget(
                    isChoose: _controller.buttonChoose.value == 1,
                    icon: Icon(Icons.public,
                        size: 18,
                        color: _controller.buttonChoose.value == 1
                            ? Colors.white
                            : Colors.red),
                    text: "Công khai",
                    onPress: () {
                      setState(() {
                        _searchController.clear();
                        _controller.setButtonChoose(1);
                      });
                    },
                  ),
                  StateHomeWidget(
                    isChoose: _controller.buttonChoose.value == 2,
                    icon: Icon(Icons.lock,
                        size: 18,
                        color: _controller.buttonChoose.value == 2
                            ? Colors.white
                            : Colors.red),
                    text: "Cá nhân",
                    onPress: () {
                      setState(() {
                        _searchController.clear();
                        _controller.setButtonChoose(2);
                      });
                    },
                  )
                ]),
              ),
              const SizedBox(height: 16),
            ],
          );
        })));
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                prefixIcon: const Icon(Icons.search),
                hintText: 'Tìm kiếm',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              _openFilterBottomSheet(context);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: ColorConstants.appColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '',
                  style: TextStyle(
                    fontSize: DimenConstants.txtMedium,
                  ),
                ),
                Icon(Icons.filter_alt_rounded)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListRouter() {
    return Expanded(
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: _controller.listTripWithSearch.length,
        itemBuilder: (BuildContext context, int index) {
          return _getRow(index);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 12,
            thickness: 12,
          );
        },
      ),
    );
  }

  Widget _getRow(int i) {
    var imageTrip = "";
    var title = "";
    var leader = "";
    var startPlace = "";
    var endPlace = "";
    var timeStart = "";
    var numberJoin = "";
    var id = "";
    Trip? trip = _controller.listTripWithSearch[i];
    List<Trip> listTrips = _controller.listTripWithSearch;
    if (listTrips.isNotEmpty) {
      imageTrip = listTrips[i].listImg?[0] ?? "";
      title = listTrips[i].title ?? "";
      leader = listTrips[i].userHostName ?? "";
      id = listTrips[0].id ?? "";
      startPlace = listTrips[i].placeStart?.name ?? "";
      endPlace = listTrips[i].placeEnd?.name ?? "";
      timeStart = listTrips[i].timeStart ?? "";
      numberJoin = listTrips[i].listIdMember?.length.toString() ?? "1";
    }
    return InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.2,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10.0),
                    bottom: Radius.circular(10.0),
                  ),
                  child: CachedMemoryImage(
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.height * 1 / 0.75,
                    height: MediaQuery.of(context).size.height * 1 / 0.75,
                    uniqueKey: imageTrip,
                    base64: imageTrip,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Icon(Icons.people, color: Colors.redAccent),
                  const SizedBox(width: 8),
                  Text(numberJoin),
                  const SizedBox(width: 4),
                ],
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 16),
                Image.asset("assets/images/icon_leader.png",),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    leader,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.timer, color: Colors.redAccent),
                          const SizedBox(width: 8),
                          Text(timeStart),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.redAccent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          startPlace,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.my_location_rounded, color: Colors.redAccent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          endPlace,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          Get.to(() => const DetailRouterScreen(), arguments: [
            {Constants.detailTrip: jsonEncode(trip)},
          ]);
        });
  }

  void _setupListen() {
    _controller.appLoading.listen((appLoading) {
      if (appLoading.isLoading) {
        OverlayLoadingProgress.start(context, barrierDismissible: false);
      } else {
        OverlayLoadingProgress.stop();
      }
    });

    _controller.appError.listen((err) {
      showErrorDialog(StringConstants.errorMsg, err.messageError, "Retry", () {
        //do sth
      });
    });

    _searchController.addListener(_performSearch);
  }

  void _performSearch() {
    String searchText = _searchController.text.toLowerCase();
    setState(() {
      Dog.d("_performSearch: $searchText");
      _controller.listTripWithSearch.value =
          _controller.listTripWithState.where((item) {
        return item.title!.toLowerCase().contains(searchText) ||
            item.id!.contains(searchText);
      }).toList();
    });
  }
}
