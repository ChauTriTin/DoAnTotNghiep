import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/model/notification_data.dart';
import 'package:appdiphuot/ui/home/noti/page_noti_controller.dart';
import 'package:appdiphuot/util/log_dog_utils.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/push_notification.dart';

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
        return Center(
          child: UIUtils.getText("No data"),
        );
      } else {
        return ListView.builder(
          padding: const EdgeInsets.only(top: 10),
          physics: const BouncingScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, i) {
            return getItemNotification(list[i], i);
          },
        );
      }
    });
  }

  Widget getItemNotification(PushNotification data, int i) {
    var notificationData = data.getNotificationData();
    return InkWell(
      onTap: () {
        _onItemNotiClick(data, notificationData)
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 25, // Kích thước rộng mong muốn
                      height: 25,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(data.userData?.avatar ??
                            StringConstants.avatarImgDefault),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        data.title ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: ColorConstants.colorTitleTrip,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                RichText(
                    text: TextSpan(
                        text: "Chuyến đi: ",
                        style: const TextStyle(
                            color: ColorConstants.colorTitleTrip,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        children: [
                          TextSpan(
                            text: data.tripDetail?.title,
                            style: const TextStyle(
                                color: ColorConstants.textColor1,
                                fontSize: DimenConstants.txtMedium,
                                fontWeight: FontWeight.w400),
                          ),
                        ])),
                const SizedBox(height: 8),
                Text(
                  data.body ?? "",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  notificationData?.time ?? "",
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

  void _onItemNotiClick(PushNotification data,
      NotificationData? notificationData) {


  }
}
