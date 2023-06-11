import 'dart:convert';
import 'dart:developer';

import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/home/home/detail/page_detail_router_screen.dart';
import 'package:appdiphuot/ui/home/home/page_home_controller.dart';
import 'package:appdiphuot/ui/home/router/create/create_router_screen.dart';
import 'package:appdiphuot/view/state_home_widget.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
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

  @override
  void initState() {
    super.initState();
    _setupListen();
    _controller.getAllRouter();
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

  final List<String> dataList = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  Widget getRow(int i) {
    var imageTrip = "";
    var title = "";
    var id = "";
    var listTrip = _controller.listTripWithState;
    Trip? trip = listTrip[i];
    if (listTrip.isNotEmpty) {
      imageTrip = listTrip[i].listImg?[0] ?? "";
      title = listTrip[i].title ?? "";
      id = listTrip[0].id ?? "";
    }
    return InkWell(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            decoration: const BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            width: MediaQuery.of(context).size.height * 1 / 7.5,
            height: MediaQuery.of(context).size.height * 1 / 7.5,
            margin: const EdgeInsets.only(right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox.fromSize(
                  size: const Size.fromRadius(48),
                  child: CachedMemoryImage(
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.height * 1 / 7.5,
                      height: MediaQuery.of(context).size.height * 1 / 7.5,
                      uniqueKey: imageTrip,
                      base64: imageTrip)),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Text(title),
          )
        ]),
        onTap: () {
          Get.to(() => const DetailRouterScreen(), arguments: [
            {Constants.detailTrip: jsonEncode(trip)},
          ]);
        });
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
            child: ListView(
              physics: const BouncingScrollPhysics(),
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
                              _controller.setButtonChoose(2);
                            });
                          },
                        )
                      ]),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12, left: 24),
                  child: const Text(
                    "Chuyen đi đang mở",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 1 / 5.5,
                  margin: const EdgeInsets.only(top: 12),
                  child: ClipRect(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: _controller.listTripWithState.length,
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
                Container(
                  margin: const EdgeInsets.only(top: 12, left: 24),
                  child: const Text(
                    "Bai danh gia ve chuyen di da hoan thanh",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 1 / 5.5,
                  margin: const EdgeInsets.only(top: 12),
                  child: ListView.separated(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: _controller.listTripWithState.length,
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
              ],
            ));
      }),
      floatingActionButton: FloatingActionButton(
        elevation: DimenConstants.elevationMedium,
        backgroundColor: ColorConstants.appColor,
        onPressed: () {
          Get.to(const CreateRouterScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
