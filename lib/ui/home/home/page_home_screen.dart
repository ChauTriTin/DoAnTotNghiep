import 'dart:convert';
import 'dart:developer';

import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/home/home/page_home_controller.dart';
import 'package:appdiphuot/ui/home/router/create/create_router_screen.dart';
import 'package:appdiphuot/util/log_dog_utils.dart';
import 'package:appdiphuot/view/state_home_widget.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../../../common/const/constants.dart';
import '../../../model/trip.dart';
import '../../../view/profile_bar_widget.dart';
import 'detail/page_detail_router_screen.dart';

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

  void _performSearch() {
    String searchText = _searchController.text.toLowerCase();
    setState(() {
      Dog.d("_performSearch: $searchText");
      _controller.listTripWithSearch.value =
          _controller.listTripWithState.where((item) {
        return item.des!.toLowerCase().contains(searchText);
      }).toList();
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

  @override
  void dispose() {
    _controller.clearOnDispose();
    super.dispose();
  }

  Widget banner = Container(
    padding: const EdgeInsets.all(24),
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0), color: Colors.orangeAccent),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding:
                        const EdgeInsets.only(left: 24, top: 24, bottom: 12),
                    child: const Text(
                      "Sự kiện đi để nhận",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    )),
                Container(
                  padding: const EdgeInsets.only(left: 24, bottom: 24),
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

  Widget searchBox() {
    return Container(
      margin: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Tìm kiếm',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(color: Colors.lightBlueAccent),
          ),
        ),
      ),
    );
  }

  Widget getRow(int i) {
    var imageTrip = "";
    var title = "";
    var startPlace = "";
    var timeStart = "";
    var numberJoin = "";
    var id = "";
    Trip? trip = _controller.listTripWithSearch[i];
    List<Trip> listTrips = _controller.listTripWithSearch;
    if (listTrips.isNotEmpty) {
      imageTrip = listTrips[i].listImg?[0] ?? "";
      title = listTrips[i].title ?? "";
      id = listTrips[0].id ?? "";
      startPlace = listTrips[i].placeStart?.name ?? "";
      timeStart = listTrips[i].timeStart ?? "";
      numberJoin = listTrips[i].listIdMember?.length.toString() ?? "1";
    }
    return InkWell(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10.0),
                ),
                child: CachedMemoryImage(
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.height * 1 / 7.5,
                  height: MediaQuery.of(context).size.height * 1 / 7.5,
                  uniqueKey: imageTrip,
                  base64: imageTrip,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.yellow),
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
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.timer, color: Colors.yellow),
                            const SizedBox(width: 8),
                            Text(timeStart),
                          ],
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(Icons.people, color: Colors.yellow),
                              const SizedBox(width: 8),
                              Text(numberJoin),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),

        // Container(
        //   margin: const EdgeInsets.only(
        //       top: DimenConstants.marginPaddingMedium,
        //       bottom: DimenConstants.marginPaddingSmall),
        //   child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        //     Container(
        //       decoration: const BoxDecoration(
        //           color: Colors.white10,
        //           borderRadius: BorderRadius.all(Radius.circular(10.0))),
        //       width: MediaQuery.of(context).size.height * 1 / 7.5,
        //       height: MediaQuery.of(context).size.height * 1 / 7.5,
        //       margin: const EdgeInsets.only(right: 10),
        //       child: ClipRRect(
        //         borderRadius: BorderRadius.circular(10),
        //         child: SizedBox.fromSize(
        //             size: const Size.fromRadius(48),
        //             child: CachedMemoryImage(
        //                 fit: BoxFit.cover,
        //                 width: MediaQuery.of(context).size.height * 1 / 7.5,
        //                 height: MediaQuery.of(context).size.height * 1 / 7.5,
        //                 uniqueKey: imageTrip,
        //                 base64: imageTrip)),
        //       ),
        //     ),
        //     Container(
        //       margin: const EdgeInsets.only(top: 8),
        //       child: Text(title),
        //     )
        //   ]),
        // ),
        onTap: () {
          Get.to(() => const DetailRouterScreen(), arguments: [
            {Constants.detailTrip: jsonEncode(trip)},
          ]);
        });
  }

  Widget _dropDown() {
    return Container(
      margin: const EdgeInsets.only(
          left: DimenConstants.marginPaddingLarge,
          right: DimenConstants.marginPaddingLarge),
      child: DropdownButtonFormField(
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        hint: Text(
          itemsDropdown.first,
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        items: itemsDropdown
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (String? value) {
          setState(() {
            selectedValue = value;
            _controller.setTypeTrip(value!);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: ColorConstants.appColor,
      ),
      backgroundColor: ColorConstants.appColorBkg,
      body: Obx(() {
        return Container(
            color: ColorConstants.appColorBkg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                banner,
                Container(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StateHomeWidget(
                          isChoose: _controller.buttonChoose.value == 0
                              ? true
                              : false,
                          icon: const Icon(Icons.done_all,
                              size: 14, color: Colors.blue),
                          text: "Tất cả",
                          onPress: () {
                            setState(() {
                              _searchController.clear();
                              _controller.setButtonChoose(0);
                            });
                          },
                        ),
                        StateHomeWidget(
                          isChoose: _controller.buttonChoose.value == 1
                              ? true
                              : false,
                          icon: const Icon(Icons.public,
                              size: 14, color: Colors.blue),
                          text: "Công khai",
                          onPress: () {
                            setState(() {
                              _searchController.clear();
                              _controller.setButtonChoose(1);
                            });
                          },
                        ),
                        StateHomeWidget(
                          isChoose: _controller.buttonChoose.value == 2
                              ? true
                              : false,
                          icon: const Icon(Icons.lock,
                              size: 14, color: Colors.blue),
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
                searchBox(),
                _dropDown(),
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 1 / 5.5,
                    child: ClipRect(
                      child: ListView.separated(
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: _controller.listTripWithSearch.length,
                        itemBuilder: (BuildContext context, int index) {
                          return getRow(index);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            width: DimenConstants.marginPaddingMedium,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
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
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
