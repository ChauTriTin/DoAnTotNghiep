import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/ui/home/chat/detail/page_detail_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:uuid/uuid.dart';

import '../../../../common/const/constants.dart';
import '../../../../common/const/string_constants.dart';
import '../../../../util/ui_utils.dart';
import '../../router/join/joine_manager_screen.dart';
import '../../user/user_preview/page_user_preview_screen.dart';

class PageDetailChatScreen extends StatefulWidget {
  const PageDetailChatScreen({
    super.key,
    required this.tripID,
  });

  final String tripID;

  @override
  State<StatefulWidget> createState() => _PageDetailChatScreenState();
}

class _PageDetailChatScreenState
    extends BaseStatefulState<PageDetailChatScreen> {
  final _controller = Get.put(PageDetailChatController());

  @override
  void initState() {
    _setupListen();
    _controller.getData(widget.tripID);
    super.initState();
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

    _controller.isTripDeleted.listen((isDeleted) {
      if (isDeleted) {
        _showWarningDialog();
      }
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
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: DimenConstants.marginPaddingSmall),
            child: IconButton(
              icon: const Icon(
                Icons.supervised_user_circle,
                color: Colors.white,
              ),
              onPressed: () {
                Get.to(
                    JoinedManagerScreen(tripdata: _controller.tripData.value));
              },
            ),
          ),
        ],
        backgroundColor: ColorConstants.appColor,
        // title: Text(_controller.tripData?.title ?? ""),
        title: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _controller.tripData.value.title ?? "",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                _controller.tripData.value.des ?? "",
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.white),
              ),
            ],
          );
        }),
      ),
      backgroundColor: ColorConstants.appColorBkg,
      body: Obx(() {
        return Chat(
          messages: _controller.messages.value,
          onSendPressed: _handleSendPressed,
          onAvatarTap: _handleTabAvatar,
          showUserAvatars: true,
          showUserNames: true,
          user: _controller.userChat.value,
        );
      }),
    );
  }

  void _showWarningDialog() {
    UIUtils.showAlertDialog(context, StringConstants.warning,
        StringConstants.removeWarning, StringConstants.ok, () {
      Get.back();
    }, null, null);
  }

  void _handleSendPressed(PartialText message) {
    if (!_controller.isCurrentUserJoinedTrip()) {
      _showWarningDialog();
      return;
    }

    final textMessage = types.TextMessage(
      author: _controller.userChat.value,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    _controller.addMessage(textMessage);
  }

  void _handleTabAvatar(User user) {
    Get.to(() => const PageUserPreviewScreen(), arguments: [
      {Constants.user: user.id}
    ]);
  }
}
