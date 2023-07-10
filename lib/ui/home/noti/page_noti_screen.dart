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
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../../../common/const/constants.dart';
import '../../../model/push_notification.dart';
import '../../../model/rate.dart';
import '../../../model/trip.dart';
import '../../../util/time_utils.dart';
import '../chat/detail/page_detail_chat_screen.dart';
import '../home/detail/page_detail_router_screen.dart';
import '../router/rate/done_trip/rate_screen.dart';

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
    String time = "";
    if (data.time != null && data.time?.isEmpty == false) {
      time =
          TimeUtils.formatDateTimeFromMilliseconds1(int.parse(data.time ?? ""));
    }

    return InkWell(
      onTap: () {
        _onItemNotiClick(data);
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
                        backgroundImage: NetworkImage(data.userAvatar ??
                            StringConstants.avatarImgDefault),
                      ),
                    ),
                    const SizedBox(width: 4,),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "${data.userName}",
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
                        text: data.tripName,
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

  Future<void> _onItemNotiClick(PushNotification data) async {
    Dog.d("_onItemNotiClick: ${data}");
    var tripId = data.tripID;

    if (data.isRouterDeleted() == true) return;

    if (tripId == null || tripId.isEmpty == true) {
      showPopupMessage(StringConstants.tripNotFound);
      return;
    }

    switch (data.notificationType) {
      case NotificationData.TYPE_MAP:
        Trip? detailTrip = await _controller.getTripDetail(tripId);
        Dog.d(" _onItemNotiClick trip: $detailTrip");
        if (detailTrip == null) {
          showPopupMessage(StringConstants.tripNotFound);
          break;
        }

        if (detailTrip.isComplete == true) {
          showPopupMessage(StringConstants.tripCompleted);
          break;
        }
        Get.to(() => MapScreen(id: tripId));
        break;

      case NotificationData.TYPE_MESSAGE:
        Get.to(() => PageDetailChatScreen(tripID: tripId));
        break;

      case NotificationData.TYPE_COMMENT:
      case NotificationData.TYPE_REMOVE:
      case NotificationData.TYPE_EXIT_ROUTER:
      case NotificationData.TYPE_JOIN_ROUTER:
        Get.to(() => DetailRouterScreen(
              tripId: tripId,
            ));
        break;
      case NotificationData.TYPE_RATE_TRIP:
        Trip? detailTrip = await _controller.getTripDetail(tripId);
        Dog.d(" _onItemNotiClick trip: $detailTrip");
        if (detailTrip == null) {
          showPopupMessage(StringConstants.tripNotFound);
          break;
        }

        var ratesMap = convertMapToRateList(detailTrip.rates);
        Rate? itemRated = ratesMap?.firstWhereOrNull(
            (element) => element.idUser == _controller.currentUser.value.uid);

        // Chưa đánh giá
        if (itemRated == null) {
          Get.to(RateScreen(id: tripId, onRateSuccess: null));
        } else {
          // đã đánh giá rồi
          showPopupMessage(StringConstants.tripRated);
        }
        break;
    }
  }

  List<Rate>? convertMapToRateList(Map<String, dynamic>? map) {
    if (map == null) return <Rate>[];
    final parsed = map.values.cast<Map<String, dynamic>>();
    return parsed.map<Rate>((json) => Rate.fromJson(json)).toList();
  }

  void showPopupMessage(String body) {
    UIUtils.showAlertDialog(
      context,
      StringConstants.warning,
      body,
      StringConstants.ok,
      null,
      null,
      null,
    );
  }
}
