import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/ui/home/chat/detail/page_detail_chat_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      body: Container(
        color: Colors.red,
      ),
    );
  }


}
