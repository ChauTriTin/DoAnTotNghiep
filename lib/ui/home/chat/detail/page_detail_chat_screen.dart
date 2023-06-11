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
      backgroundColor: ColorConstants.appColorBkg,
      body: Obx(() {
        return Chat(
          messages: _controller.messages.value,
          onSendPressed: _handleSendPressed,
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
}
