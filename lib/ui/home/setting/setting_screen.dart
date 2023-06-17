import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/authentication/landing_page/page_authentication_screen.dart';
import 'package:appdiphuot/ui/home/setting/setting_controller.dart';
import 'package:appdiphuot/ui/home/user/page_user_controller.dart';
import 'package:appdiphuot/ui/home/user/place_detail/page_detail_trip_screen.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../../../common/extension/build_context_extension.dart';
import '../../../model/place.dart';
import '../../../model/trip.dart';
import '../../../view/profile_bar_widget.dart';
import '../../user_singleton_controller.dart';
import '../home/detail/page_detail_router_screen.dart';

class PageSettingScreen extends StatefulWidget {
  const PageSettingScreen({
    super.key,
  });

  @override
  State<PageSettingScreen> createState() => _PageSettingScreen();
}

class _PageSettingScreen extends BaseStatefulState<PageSettingScreen> {
  final _controller = Get.put(SettingController());

  @override
  void initState() {
    super.initState();
    _setupListen();
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
                name: UserSingletonController.instance.getName(),
                state: StringConstants.status,
                linkAvatar: UserSingletonController.instance.getAvatar(),
              ),
              Expanded(child: buildBody())
            ],
          );
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
            UserSingletonController.instance.getName(),
            style: UIUtils.getStyleTextMedium600(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: DimenConstants.marginPaddingTiny,
          ),
          Text(
            UserSingletonController.instance.getEmail(),
            style: UIUtils.getStyleTextSmall300(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: DimenConstants.marginPaddingLarge,
          ),
          getText(
              ColorConstants.colorProfile, StringConstants.editProfile, () {}),
          const SizedBox(
            height: DimenConstants.marginPaddingMedium,
          ),
          Padding(
            padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
            child: Text(
              StringConstants.generalSetting,
              style: UIUtils.getStyleText(),
            ),
          ),
          getDarkmode(),
          const SizedBox(
            height: DimenConstants.marginPaddingMedium,
          ),
          getText(
              ColorConstants.colorLanguage, StringConstants.language, () {}),
          const SizedBox(
            height: DimenConstants.marginPaddingMedium,
          ),
          getText(ColorConstants.colorAbout, StringConstants.about, () {}),
          const SizedBox(
            height: DimenConstants.marginPaddingMedium,
          ),
          getText(ColorConstants.colorTermCondition,
              StringConstants.termCondition, () {}),
          const SizedBox(
            height: DimenConstants.marginPaddingMedium,
          ),
          getText(ColorConstants.colorPolicy, StringConstants.policy, () {}),
          const SizedBox(
            height: DimenConstants.marginPaddingMedium,
          ),
          getText(ColorConstants.colorRateApp, StringConstants.rate, () {}),
          const SizedBox(
            height: DimenConstants.marginPaddingMedium,
          ),
        ]));
  }

  Widget getDarkmode() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          const SizedBox(
            width: DimenConstants.marginPaddingMedium,
          ),
          Container(
            width: DimenConstants.circleShape,
            height: DimenConstants.circleShape,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: ColorConstants.colorMode,
            ),
          ),
          const SizedBox(
            width: DimenConstants.marginPaddingMedium,
          ),
          Expanded(
              child: Text(
            StringConstants.mode,
            style: UIUtils.getStyleTextSmall400(),
          )),
          const SizedBox(
            width: DimenConstants.marginPaddingMedium,
          ),
          const Icon(
            Icons.keyboard_arrow_right,
            color: ColorConstants.iconColor,
            size: DimenConstants.iconSizeSmall,
          ),
          const SizedBox(
            width: DimenConstants.marginPaddingMedium,
          ),
        ],
      ),
    );
  }

  Widget getText(
    Color? color,
    String msg,
    GestureTapCallback? onItemPress,
  ) {
    return InkWell(
      onTap: onItemPress,
      child: Row(
        children: [
          const SizedBox(
            width: DimenConstants.marginPaddingMedium,
          ),
          Container(
            width: DimenConstants.circleShape,
            height: DimenConstants.circleShape,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color ?? ColorConstants.appColor,
            ),
          ),
          const SizedBox(
            width: DimenConstants.marginPaddingMedium,
          ),
          Expanded(
              child: Text(
            msg,
            style: UIUtils.getStyleTextSmall400(),
          )),
          const SizedBox(
            width: DimenConstants.marginPaddingMedium,
          ),
          const Icon(
            Icons.keyboard_arrow_right,
            color: ColorConstants.iconColor,
            size: DimenConstants.iconSizeSmall,
          ),
          const SizedBox(
            width: DimenConstants.marginPaddingMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return IconButton(
      iconSize: DimenConstants.avatarProfile2,
      icon: CircleAvatar(
        backgroundColor: ColorConstants.borderTextInputColor,
        radius: DimenConstants.avatarProfile2 / 2,
        child: CircleAvatar(
          radius: DimenConstants.avatarProfile2 / 2 - DimenConstants.logoStroke,
          backgroundImage:
              NetworkImage(UserSingletonController.instance.getAvatar()),
        ),
      ),
      onPressed: () {},
    );
  }
}
