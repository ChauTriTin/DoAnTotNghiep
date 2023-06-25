import 'dart:convert';

import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/home/user/place_detail/page_detail_trip_screen.dart';
import 'package:appdiphuot/ui/home/user/user_preview/page_user_preview_controller.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../../../../model/trip.dart';
import '../../../../util/log_dog_utils.dart';
import '../../../user_singleton_controller.dart';

class PageUserPreviewScreen extends StatefulWidget {
  const PageUserPreviewScreen({
    super.key,
  });

  @override
  State<PageUserPreviewScreen> createState() => _PageUserPreviewScreenState();
}

class _PageUserPreviewScreenState extends BaseStatefulState<PageUserPreviewScreen> {
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
          toolbarHeight: 0,
          backgroundColor: ColorConstants.appColor,
        ),
        backgroundColor: ColorConstants.colorWhite,
        body: Obx(() {
          return buildBody();
        }));
  }

  Widget buildBody() {
    return Container(
        width: double.infinity,
        color: ColorConstants.colorWhite,
        child: ListView(physics: const BouncingScrollPhysics(), children: [
          const SizedBox(
            height: DimenConstants.marginPaddingMedium,
          ),
          _buildAvatar(),
          const SizedBox(
            height: DimenConstants.marginPaddingTiny,
          ),
          Text(
            _controller.userData.value.name ?? "",
            style: UIUtils.getStyleTextLarge500(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: DimenConstants.marginPaddingLarge,
          ),
          _buildUserInfo(Icons.email, StringConstants.email, _controller.userData.value.email ?? ""),
          _buildUserInfo(Icons.calendar_month, StringConstants.birthday, _controller.userData.value.birthday ?? ""),
          _buildUserInfo(Icons.location_city, StringConstants.address, _controller.userData.value.address ?? ""),
          _buildUserInfo(Icons.phone_android, StringConstants.phone, _controller.userData.value.phone ?? ""),
          _buildUserInfo(Icons.pedal_bike, StringConstants.bsx, _controller.userData.value.bsx ?? ""),
          _buildUserInfo(Icons.transgender, StringConstants.gender, _controller.getUserGender()),
          _buildTripInfo(),
        ]));
  }

  Widget _buildAvatar() {
    return IconButton(
        iconSize: DimenConstants.avatarProfile,
        onPressed: () {},
        icon: CircleAvatar(
          backgroundColor: ColorConstants.borderTextInputColor,
          radius: DimenConstants.avatarProfile / 2,
          child: CircleAvatar(
            radius:
                DimenConstants.avatarProfile / 2 - DimenConstants.logoStroke,
            backgroundImage:
                NetworkImage(_controller.userData.value.avatar ?? StringConstants.avatarImgDefault)),
          ),
        );
  }

  Widget _buildUserInfo(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: DimenConstants.marginPaddingMedium, right: DimenConstants.marginPaddingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 2,
              child: Icon(icon)),
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 0, right: 0),
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
    return Padding(
        padding: const EdgeInsets.only(top: DimenConstants.marginPaddingMedium, left: DimenConstants.marginPaddingLarge, right: DimenConstants.marginPaddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              color: ColorConstants.dividerGreyColor,
              thickness: DimenConstants.dividerHeight,
            ),
            const SizedBox(
              height: DimenConstants.marginPaddingMedium,
            ),
            UIUtils.getTextSpanCount(StringConstants.tripParticipatedCount, _controller.trips.length),
            UIUtils.getTextSpanCount(StringConstants.leadTripCount, _controller.tripsHost.length),
            UIUtils.getTextSpanCount(StringConstants.totalKm, _controller.totalKm.value),
            const SizedBox(
              height: DimenConstants.marginPaddingMedium,
            ),
          ],
        ));
  }
}
