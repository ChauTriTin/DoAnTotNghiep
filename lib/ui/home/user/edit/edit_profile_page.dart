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

import '../../../../view/profile_bar_widget.dart';
import '../../../user_singleton_controller.dart';
import 'edit_profile_controller.dart';

class PageEditProfile extends StatefulWidget {
  const PageEditProfile({
    super.key,
  });

  @override
  State<PageEditProfile> createState() => _PageEditProfile();
}

class _PageEditProfile extends BaseStatefulState<PageEditProfile> {
  final _controller = Get.put(EditProfileController());

  @override
  void initState() {
    super.initState();
    _controller.getData();
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
          backgroundColor: ColorConstants.appColor,
          title: const Text(StringConstants.editProfile),
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
          _changeAvatar()
        ]));
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

  Widget _changeAvatar() {
    return InkWell(
      onTap: () {
        _openSelectImageBottomSheet(context);
      },
      child: Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 14, bottom: 16),
            child: const Center(
              child: Text(
                StringConstants.updateAvatar,
                style: TextStyle(color: Colors.blue),
              ),
            ),
          )),
    );
  }

  void _openSelectImageBottomSheet(BuildContext context) {
    Get.bottomSheet(Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(DimenConstants.borderBottomAuth),
            topRight: Radius.circular(DimenConstants.borderBottomAuth),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _controller.openGallery();
                  Get.back();
                },
                child: const ListTile(
                  leading: Icon(Icons.photo),
                  title: Text(StringConstants.openGallery),
                ),
              )),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _controller.openCamera();
                Get.back();
              },
              child: const ListTile(
                leading: Icon(Icons.camera),
                title: Text(StringConstants.openCamera),
              ),
            ),
          )
        ],
      ),
    ));
  }

}
