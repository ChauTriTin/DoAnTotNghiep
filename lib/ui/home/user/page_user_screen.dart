import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/authentication/landing_page/page_authentication_screen.dart';
import 'package:appdiphuot/ui/home/user/page_user_controller.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../../../model/place.dart';
import '../home/detail/page_detail_router_screen.dart';

class PageUserScreen extends StatefulWidget {
  const PageUserScreen({
    super.key,
  });

  @override
  State<PageUserScreen> createState() => _PageUserScreenState();
}

class _PageUserScreenState extends BaseStatefulState<PageUserScreen> {
  final _controller = Get.put(PageUserController());

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
          IconButton(
              iconSize: DimenConstants.avatarProfile,
              onPressed: _onAvatarPressed,
              icon: CircleAvatar(
                backgroundColor: ColorConstants.borderTextInputColor,
                radius: DimenConstants.avatarProfile / 2,
                child: CircleAvatar(
                  radius: DimenConstants.avatarProfile / 2 - DimenConstants.logoStroke,
                  backgroundImage: NetworkImage(_controller.getAvatar()),
                ),
              )),
          const SizedBox(
            height: DimenConstants.marginPaddingTiny,
          ),
          Text(
            _controller.getName(),
            style: UIUtils.getStyleTextLarge500(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: DimenConstants.marginPaddingLarge,
          ),
          Padding(
            padding: const EdgeInsets.only(left: DimenConstants.marginPaddingMedium),
            child: Text(
              StringConstants.tripParticipated,
              style: UIUtils.getStyleText(),
            ),
          ),
          const SizedBox(
            height: DimenConstants.marginPaddingMedium,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 1 / 5.5,
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 20, right: 20),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: _controller.places.length,
              itemBuilder: (BuildContext context, int index) {
                return getTripRowItem(index);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  width: DimenConstants.marginPaddingMedium,
                );
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    color: ColorConstants.dividerColor,
                    thickness: DimenConstants.dividerHeight,
                  ),
                  const SizedBox(
                    height: DimenConstants.marginPaddingMedium,
                  ),
                  getTextSpanCount(StringConstants.tripParticipatedCount, _controller.tripParticipatedCount.value),
                  getTextSpanCount(StringConstants.leadTripCount, _controller.leadTripCount.value),
                  getTextSpanCount(StringConstants.totalKm, _controller.totalKm.value),
                  const SizedBox(
                    height: DimenConstants.marginPaddingMedium,
                  ),
                  const Divider(
                    color: ColorConstants.dividerColor,
                    thickness: DimenConstants.dividerHeight,
                  ),
                  const SizedBox(
                    height: DimenConstants.marginPaddingMedium,
                  ),
                  UIUtils.getLoginOutlineButton(
                    StringConstants.signOut,
                    _signOut,
                  )
                ],
              )),
        ]));
  }

  Widget getTextSpanCount(String title, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DimenConstants.marginPaddingMedium),
      child: RichText(
          text: TextSpan(text: title, style: UIUtils.getStyleText(), children: [
        TextSpan(
          text: count.toString(),
          style: UIUtils.getStyleText500(),
        ),
      ])),
    );
  }

  void _signOut() {
    _controller.signOut();
    Get.offAll(const AuthenticationScreen());
  }

  void _onAvatarPressed() {
    _openSelectImageBottomSheet(context);
  }

  Widget getTripRowItem(int index) {
    var place = _controller.places[index];
    return InkWell(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            color: Colors.white10,
            width: MediaQuery.of(context).size.height * 1 / 7.5,
            height: MediaQuery.of(context).size.height * 1 / 7.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox.fromSize(size: const Size.fromRadius(48), child: Image.network(StringConstants.linkImg, fit: BoxFit.cover)),
            ),
          ),
          const SizedBox(
            height: DimenConstants.marginPaddingSmall,
          ),
          Text(
            place.name,
            textAlign: TextAlign.start,
            style: UIUtils.getStyleText(),
          ),
        ]),
        onTap: () {
          _onPressTripItem(place);
        });
  }

  void _onPressTripItem(Place place) {
    Get.to(const DetailRouterScreen());
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
