import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/authentication/landing_page/page_authentication_screen.dart';
import 'package:appdiphuot/ui/home/user/page_user_controller.dart';
import 'package:appdiphuot/ui/home/user/place_detail/trip_detail_controller.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../../../../view/profile_bar_widget.dart';

class PageDetailTrip extends StatefulWidget {
  const PageDetailTrip({
    super.key,
  });

  @override
  State<PageDetailTrip> createState() => _PageDetailTrip();
}

class _PageDetailTrip extends BaseStatefulState<PageDetailTrip> {
  final _controller = Get.put(TripDetailController());

  @override
  void initState() {
    super.initState();
    _setupListen();
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
        body: Column(
          children: [
            ProfileBarWidget(
              name: _controller.getName(),
              state: "⬤ Online",
              linkAvatar: _controller.getAvatar(),
            ),
            Expanded(child: Obx(() {
              return buildBody();
            }))
          ],
        ));
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
                  height: DimenConstants.marginPaddingMedium,
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
                  itemCount: _controller.pitStops.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _getPitStop(index);
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

  Widget _getPitStop(int index) {
    var pitstop = _controller.pitStops.value[index];
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: DimenConstants.marginPaddingSmall),
      child: Text(
        "• $pitstop",
        style: UIUtils.getStyleText(),
      ),
    );
  }

  Widget buildTopImageInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        Container(
          color: Colors.white10,
          width: MediaQuery.of(context).size.height * 1 / 6,
          height: MediaQuery.of(context).size.height * 1 / 6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox.fromSize(
                size: const Size.fromRadius(48),
                child: Image.network(_controller.place.value.getFirstImageUrl(),
                    fit: BoxFit.cover)),
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
              _controller.place.value.name,
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
                  "Desscription ...",
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: UIUtils.getStyleText(),
                ),
              ],
            )

            // Expanded(
            //   child: Text(
            //     'This is a long text that may exceed the available width of the column.',
            //     softWrap: true,
            //   ),
            // )
          ],
        ))
      ],
    );
  }
}
