import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/home/user/user_preview/page_user_preview_controller.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../../../../util/log_dog_utils.dart';

class PageUserPreviewScreen extends StatefulWidget {
  const PageUserPreviewScreen({
    super.key,
  });

  @override
  State<PageUserPreviewScreen> createState() => _PageUserPreviewScreenState();
}

class _PageUserPreviewScreenState
    extends BaseStatefulState<PageUserPreviewScreen> {
  final _controller = Get.put(PageUserPreviewController());

  @override
  void initState() {
    super.initState();
    _setupListen();
    var userId = Get.arguments[0][Constants.user];
    Dog.d("initState: userId: ${userId.toString()}");
    _controller.userId.value = userId;
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
          title: const Text(StringConstants.about),
        ),
        backgroundColor: ColorConstants.screenBg,
        body: Obx(() {
          return buildBody();
        }));
  }

  Widget buildBody() {
    return SizedBox(
        width: double.infinity,
        child: ListView(physics: const BouncingScrollPhysics(), children: [
          _buildAvatar(),
          _buildUserInfo(),
          _buildTripInfo(),
        ]));
  }

  Widget _buildAvatar() {
    double rate = _controller.userData.value.getRate();
    int rateCount = _controller.userData.value.rates?.length ?? 0;
    return Card(
      shape: UIUtils.getCardCorner(),
      margin: const EdgeInsets.all(DimenConstants.marginPaddingSmall),
      color: ColorConstants.cardBg,
      shadowColor: Colors.grey,
      elevation: DimenConstants.cardElevation,
      child: Column(
        children: [
          const SizedBox(
            height: DimenConstants.marginPaddingMedium,
          ),
          IconButton(
            iconSize: DimenConstants.avatarProfile2,
            onPressed: () {},
            icon: CircleAvatar(
              backgroundColor: ColorConstants.borderTextInputColor,
              radius: DimenConstants.avatarProfile2 / 2,
              child: CircleAvatar(
                  radius: DimenConstants.avatarProfile2 / 2 -
                      DimenConstants.logoStroke,
                  backgroundImage: NetworkImage(
                      _controller.userData.value.avatar ??
                          StringConstants.avatarImgDefault)),
            ),
          ),
          const SizedBox(
            height: DimenConstants.marginPaddingTiny,
          ),
          Text(
            _controller.userData.value.name ?? "",
            style: UIUtils.getStyleTextLarge500(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: DimenConstants.marginPaddingMedium,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RatingBar.builder(
                initialRating: rate,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemSize: 20.0,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.orange,
                ),
                ignoreGestures: true,
                onRatingUpdate: (double value) {},
              ),
              const SizedBox(
                width: DimenConstants.marginPaddingTiny,
              ),
              Text(
                rate.toStringAsFixed(1),
                style: const TextStyle(
                    color: ColorConstants.colorGreen,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                width: 6,
              ),
              const Text("|",
                  style: TextStyle(color: ColorConstants.textColorDisable)),
              const SizedBox(
                width: 6,
              ),
              Text(
                "$rateCount đánh giá",
                style: const TextStyle(
                    color: ColorConstants.colorGreen,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              )
            ],
          ),
          const SizedBox(
            height: DimenConstants.marginPaddingLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Card(
      shape: UIUtils.getCardCorner(),
      margin: const EdgeInsets.all(DimenConstants.marginPaddingSmall),
      color: ColorConstants.cardBg,
      shadowColor: Colors.grey,
      elevation: DimenConstants.cardElevation,
      child: Padding(
        padding: const EdgeInsets.only(
            top: DimenConstants.marginPaddingMLarge,
            bottom: DimenConstants.marginPaddingMLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: DimenConstants.marginPaddingLarge,
                  right: DimenConstants.marginPaddingMLarge),
              child: Text(
                StringConstants.about,
                style: UIUtils.getStyleText500Medium1(),
              ),
            ),
            const SizedBox(
              height: DimenConstants.marginPaddingSmall,
            ),
            const Padding(
              padding: EdgeInsets.only(
                  left: DimenConstants.marginPaddingLarge,
                  right: DimenConstants.marginPaddingMLarge),
              child: Divider(
                color: ColorConstants.dividerColor,
                thickness: DimenConstants.dividerHeight,
              ),
            ),
            const SizedBox(
              height: DimenConstants.marginPaddingSmall,
            ),
            _buildRowUserInfo(Icons.email, StringConstants.email,
                _controller.userData.value.email ?? ""),
            _buildRowUserInfo(Icons.calendar_month, StringConstants.birthday,
                _controller.userData.value.birthday ?? ""),
            _buildRowUserInfo(Icons.location_city, StringConstants.address,
                _controller.userData.value.address ?? ""),
            _buildRowUserInfo(Icons.phone_android, StringConstants.phone,
                _controller.userData.value.phone ?? ""),
            _buildRowUserInfo(Icons.pedal_bike, StringConstants.bsx,
                _controller.userData.value.bsx ?? ""),
            _buildRowUserInfo(Icons.transgender, StringConstants.gender,
                _controller.getUserGender()),
          ],
        ),
      ),
    );
  }

  Widget _buildRowUserInfo(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(
          left: DimenConstants.marginPaddingSmall,
          right: DimenConstants.marginPaddingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 2, child: Icon(icon)),
          Expanded(
            flex: 8,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 0, right: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    value,
                    style: UIUtils.getStyleText(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTripInfo() {
    return Card(
      shape: UIUtils.getCardCorner(),
      margin: const EdgeInsets.all(DimenConstants.marginPaddingSmall),
      color: ColorConstants.cardBg,
      shadowColor: Colors.grey,
      elevation: DimenConstants.cardElevation,
      child: Padding(
          padding: const EdgeInsets.only(
              top: DimenConstants.marginPaddingMLarge,
              bottom: DimenConstants.marginPaddingSmall,
              left: DimenConstants.marginPaddingLarge,
              right: DimenConstants.marginPaddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringConstants.statistic,
                style: UIUtils.getStyleText500Medium1(),
              ),
              const SizedBox(
                height: DimenConstants.marginPaddingSmall,
              ),
              const Divider(
                color: ColorConstants.dividerColor,
                thickness: DimenConstants.dividerHeight,
              ),
              const SizedBox(
                height: DimenConstants.marginPaddingSmall,
              ),
              UIUtils.getTextSpanCount(
                  "👨‍👧‍👦 ${StringConstants.tripParticipatedCount}",
                  _controller.trips.length +
                      _controller.tripsInProgress.length),
              UIUtils.getTextSpanCount("🤴 ${StringConstants.leadTripCount}",
                  _controller.tripsHost.length),
              UIUtils.getTextSpanCountDouble(
                  "📏 ${StringConstants.totalKm}", _controller.totalKm.value),
            ],
          )),
    );
  }
}
