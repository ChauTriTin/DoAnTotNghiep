import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/model/trip.dart';
import 'package:appdiphuot/ui/authentication/landing_page/page_authentication_screen.dart';
import 'package:appdiphuot/ui/home/user/page_user_controller.dart';
import 'package:appdiphuot/ui/home/user/place_detail/trip_detail_controller.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../../../../view/profile_bar_widget.dart';

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
          toolbarHeight: 0,
          backgroundColor: ColorConstants.appColor,
        ),
        backgroundColor: ColorConstants.colorWhite,
        body: Obx(() {
          return Column(
            children: [
              ProfileBarWidget(
                name: _controller.getName(),
                state: "⬤ Online",
                linkAvatar: _controller.getAvatar(),
              ),
              Expanded(child: buildBody())
            ],
          );
        }));
  }

  Widget buildBody() {
    return Container(
        width: MediaQuery.of(context).size.width,
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

                UIUtils.getTextSpanCount(StringConstants.leadTripName,
                    _controller.tripParticipatedCount.value),
                UIUtils.getTextSpanCount(
                    StringConstants.totalKm, _controller.leadTripCount.value),
                UIUtils.getTextSpanCount(
                    StringConstants.pitStopCount, _controller.totalKm.value),

                ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.tripData.listPlace?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return _getPlaces(index);
                  },
                ),

                UIUtils.getTextSpanCount(StringConstants.participantsCount,
                    _controller.totalKm.value),
                UIUtils.getTextSpanCount(
                    StringConstants.pitStopCount, _controller.totalKm.value),
                UIUtils.getTextSpanCount(
                    StringConstants.startDay, _controller.totalKm.value),
                UIUtils.getTextSpanCount(
                    StringConstants.endDay, _controller.totalKm.value),
                UIUtils.getTextSpanCount(
                    StringConstants.totalTravelDay, _controller.totalKm.value),
              ],
            )));
  }

  Widget _getPlaces(int index) {
    var place = widget.tripData.listPlace?[index];
    if (place == null) return Container();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: DimenConstants.marginPaddingSmall),
      child: Text(
        "• ${place.name}",
        style: UIUtils.getStyleText(),
      ),
    );
  }

  Widget buildTopImageInfo() {
    var itemSize = MediaQuery.of(context).size.height * 1 / 6;
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
              size: const Size.fromRadius(48),
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
