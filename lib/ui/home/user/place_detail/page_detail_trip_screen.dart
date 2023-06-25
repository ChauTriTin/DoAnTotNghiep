import 'dart:convert';
import 'dart:developer';

import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/model/trip.dart';
import 'package:appdiphuot/ui/home/user/place_detail/trip_detail_controller.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../../../../common/const/constants.dart';
import '../../../user_singleton_controller.dart';
import '../../../../view/profile_bar_widget.dart';
import '../../home/detail/page_detail_router_screen.dart';
import '../../setting/setting_screen.dart';

class PageDetailTrip extends StatefulWidget {
  const PageDetailTrip({
    super.key,
    required this.tripData,
  });

  final Trip tripData;

  @override
  State<PageDetailTrip> createState() => _PageDetailTrip();
}

class _PageDetailTrip extends BaseStatefulState<PageDetailTrip> {
  final _controller = Get.put(TripDetailController());

  @override
  void initState() {
    super.initState();
    _setupListen();
    _controller.setTripData(widget.tripData);
    _controller.getData();
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
    OverlayLoadingProgress.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          backgroundColor: ColorConstants.appColor,
          title: const Text(StringConstants.tripDetail),
        ),
        backgroundColor: ColorConstants.colorWhite,
        body: Obx(() {
          return Column(
            children: [
              Expanded(child: buildBody())
            ],
          );
        }));
  }

  void _navigateToSettingScreen() {
    Get.to(const PageSettingScreen());
  }

  Widget buildBody() {
    var trip = widget.tripData;
    return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        color: ColorConstants.colorWhite,
        padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTopImageInfo(),
                //
                const SizedBox(
                  height: DimenConstants.marginPaddingExtraLarge,
                ),

                UIUtils.getTextSpan(StringConstants.leadTripName,
                    _controller.userHostTrip.value.name ?? ""),

                const SizedBox(
                  height: DimenConstants.marginPaddingMedium,
                ),
                UIUtils.getTextSpanCount(
                    StringConstants.totalKm, _controller.totalKm.value),

                const SizedBox(
                  height: DimenConstants.marginPaddingMedium,
                ),
                UIUtils.getTextSpanCount(
                    StringConstants.pitStopCount, trip.listPlace?.length ?? 0),

                ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: trip.listPlace?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    var place = widget.tripData.listPlace?[index];
                    return _getRowItem(index, place?.name ?? "");
                  },
                ),

                const SizedBox(
                  height: DimenConstants.marginPaddingMedium,
                ),
                UIUtils.getTextSpanCount(StringConstants.participantsCount,
                    trip.listIdMember?.length ?? 0),

                ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _controller.usersParticipated.length,
                  itemBuilder: (BuildContext context, int index) {
                    var userName =
                        _controller.usersParticipated.value[index].name;
                    return _getRowItem(index, userName);
                  },
                ),

                const SizedBox(
                  height: DimenConstants.marginPaddingMedium,
                ),
                UIUtils.getTextSpan(
                    StringConstants.startDay, trip.timeStart ?? ""),

                const SizedBox(
                  height: DimenConstants.marginPaddingMedium,
                ),
                UIUtils.getTextSpan(StringConstants.endDay, trip.timeEnd ?? ""),

                const SizedBox(
                  height: DimenConstants.marginPaddingMedium,
                ),
                UIUtils.getTextSpanCount(
                    StringConstants.totalTravelDay, _controller.totalKm.value),
                const SizedBox(
                  height: DimenConstants.marginPaddingMedium,
                ),
                _seeMore(),
              ],
            )));
  }

  Widget _seeMore() {
    return InkWell(
      onTap: () {
        log("_seeMore-tripData: ${widget.tripData}");
        Get.to(() => const DetailRouterScreen(), arguments: [
          {Constants.detailTrip: jsonEncode(widget.tripData)},
        ]);
      },
      child: Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 14, bottom: 16),
            child: const Center(
              child: Text(
                StringConstants.gotoDetailRouter,
                style: TextStyle(color: Colors.blue),
              ),
            ),
          )),
    );
  }

  Widget _getRowItem(int index, String? value) {
    if (value == null) return Container();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: DimenConstants.marginPaddingSmall),
      child: Text(
        "• $value",
        style: UIUtils.getStyleText(),
      ),
    );
  }

  Widget buildTopImageInfo() {
    var itemSize = MediaQuery
        .of(context)
        .size
        .height * 1 / 6;
    var trip = widget.tripData;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        Container(
          color: Colors.white10,
          width: itemSize,
          height: itemSize,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox.fromSize(
              child: CachedMemoryImage(
                  fit: BoxFit.cover,
                  width: itemSize,
                  height: itemSize,
                  uniqueKey: trip.getFirstImageUrl(),
                  base64: trip.getFirstImageUrl()),
            ),
          ),
        ),
        const SizedBox(
          width: DimenConstants.marginPaddingMedium,
        ),
        Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${trip.title}",
                  textAlign: TextAlign.start,
                  style: UIUtils.getStyleTextLarge500(),
                ),
                const SizedBox(
                  height: DimenConstants.marginPaddingMedium,
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    Text(
                      "${trip.des}",
                      textAlign: TextAlign.start,
                      softWrap: true,
                      style: UIUtils.getStyleText(),
                    ),
                  ],
                )
              ],
            ))
      ],
    );
  }
}
