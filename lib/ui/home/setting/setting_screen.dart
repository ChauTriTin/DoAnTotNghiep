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
    return Container();
  }
}
