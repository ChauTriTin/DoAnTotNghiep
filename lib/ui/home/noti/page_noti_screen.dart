import 'dart:convert';

import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/model/notification_data.dart';
import 'package:appdiphuot/ui/home/noti/page_noti_controller.dart';
import 'package:appdiphuot/ui/home/router/join/joine_manager_screen.dart';
import 'package:appdiphuot/ui/home/router/map/map_screen.dart';
import 'package:appdiphuot/util/log_dog_utils.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../common/const/constants.dart';
import '../../../model/push_notification.dart';
import '../../../util/time_utils.dart';
import '../chat/detail/page_detail_chat_screen.dart';
import '../home/detail/page_detail_router_screen.dart';

class PageNotiScreen extends StatefulWidget {
  const PageNotiScreen({
    super.key,
  });

  @override
  State<PageNotiScreen> createState() => _PageNotiScreenState();
}

class _PageNotiScreenState extends BaseStatefulState<PageNotiScreen> {
  final _controller = Get.put(PageNotiController());

  @override
  void initState() {
    super.initState();
    _setupListen();
    _controller.getData();
  }

  void _setupListen() {
    _controller.appLoading.listen((appLoading) {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.screenBg, body: _buildList());
  }

  Widget _buildList() {
    return Obx(() {
      var list = _controller.listNotification.value;
      Dog.d(">>>_buildList list ${list.toString()}");
      if (list.isEmpty) {
        return Container(
          margin: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/files/no_data.json'),
              Text(
                "Không có thông báo nào",
                style: UIUtils.getStyleText(),
              )
            ],
          ),
        );
      } else {
        return ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          physics: const BouncingScrollPhysics(),
          itemCount: _controller.listNotification.value.length,
          itemBuilder: (context, i) {
            var data = _controller.listNotification.value[i];
            return getItemNotification(data);
          },
        );
      }
    });
  }

  Widget getItemNotification(PushNotification data) {
    var notificationData = data.getNotificationData();
    String time = "";
    if (notificationData?.time != null &&
        notificationData?.time?.isEmpty == false) {
      time = TimeUtils.formatDateTimeFromMilliseconds1(
          int.parse(notificationData?.time ?? ""));
    }

    String titleTrip = data.tripDetail?.title ?? "";
    Dog.d("titleTripOfNoti: $titleTrip");

    return InkWell(
      onTap: () {
        _onItemNotiClick(data, notificationData);
      },
      child: Card(
          shape: UIUtils.getCardCorner(),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          color: ColorConstants.cardBg,
          shadowColor: Colors.grey,
          elevation: DimenConstants.cardElevation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.colorTitleTrip,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(data.userData?.avatar ??
                            StringConstants.avatarImgDefault),
                      ),
                    ),
                    const SizedBox(width: 4,),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "${data.userData?.name}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 6),
                RichText(
                    text: TextSpan(
                        text: "📍 Chuyến đi: ",
                        style: const TextStyle(
                            color: ColorConstants.colorTitleTrip,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                        children: [
                      TextSpan(
                        text: titleTrip,
                        style: const TextStyle(
                            color: ColorConstants.textColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w400),
                      ),
                    ])),
                const SizedBox(height: 8),
                Text(
                  "💬 ${data.body}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  time ?? "",
                  style: const TextStyle(
                    fontSize: 14,
                    color: ColorConstants.textColorDisable,
                  ),
                )
              ],
            ),
          )),
    );
  }

  void _onItemNotiClick(
      PushNotification data, NotificationData? notificationData) {
    Dog.d("_onItemNotiClick: ${data.tripDetail.toString()}");

    if (notificationData?.isRouterDeleted() == true) return;

    if (data.tripDetail == null) {
      showNoTripFoundPopup();
      return;
    }

    switch (notificationData?.notificationType) {
      case NotificationData.TYPE_MAP:
        Get.to(() => MapScreen(id: data.tripDetail?.id ?? ""));
        break;

      case NotificationData.TYPE_MESSAGE:
        Get.to(() => const PageDetailChatScreen(), arguments: [
          {Constants.detailChat: jsonEncode(data.tripDetail)},
        ]);
        break;

      case NotificationData.TYPE_COMMENT:
      case NotificationData.TYPE_REMOVE:
      case NotificationData.TYPE_EXIT_ROUTER:
      case NotificationData.TYPE_JOIN_ROUTER:
        Get.to(() => const DetailRouterScreen(), arguments: [
          {Constants.detailTrip: jsonEncode(data.tripDetail)},
        ]);
        break;
    }
  }

  void showNoTripFoundPopup() {
    UIUtils.showAlertDialog(
      context,
      StringConstants.warning,
      StringConstants.tripNotFound,
      StringConstants.ok,
      null,
      null,
      null,
    );
  }
}
