import 'dart:convert';

import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/ui/home/chat/detail/page_detail_chat_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../../../common/const/constants.dart';
import '../../../../model/trip.dart';
import '../../../../util/log_dog_utils.dart';
import '../../user/user_preview/page_user_preview_screen.dart';

class PageDetailChatScreen extends StatefulWidget {
  const PageDetailChatScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _PageDetailChatScreenState();
}

class _PageDetailChatScreenState extends BaseStatefulState<PageDetailChatScreen> {
  final _controller = Get.put(PageDetailChatController());

  @override
  void initState() {
    var tripData = Get.arguments[0][Constants.detailChat];
    Dog.d("initState: tripData: ${tripData.toString()}");
    _controller.tripData = Trip.fromJson(jsonDecode(tripData ?? ""));

    _controller.getData();
    super.initState();
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
        backgroundColor: ColorConstants.appColor,
        title: Text(_controller.tripData?.title ?? ""),
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

  void _handleSendPressed(PartialText message) {
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
      { Constants.user: user.toJson() }
    ]);
  }
}
