import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/home/chat/detail/page_detail_chat_screen.dart';
import 'package:appdiphuot/ui/home/chat/page_chat_controller.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageChatScreen extends StatefulWidget {
  const PageChatScreen({
    super.key,
  });

  @override
  State<PageChatScreen> createState() => _PageChatScreenState();
}

class _PageChatScreenState extends BaseStatefulState<PageChatScreen> {
  final _controller = Get.put(PageChatController());

  @override
  void initState() {
    super.initState();
    _setupListen();
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
      backgroundColor: ColorConstants.appColorBkg,
      body: ListView.separated(
        padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: DimenConstants.marginPaddingSmall);
        },
        itemBuilder: (BuildContext context, int index) {
          return _getRowConversation(index);
        },
      ),
    );
  }

  Widget _getRowConversation(int index) {
    return Card(
      elevation: 4.0,
      child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(24),
                      child: const Icon(Icons.message),
                    ),
                  )),
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Title Message",
                        style: UIUtils.getStyleText(),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Description Message",
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          onTap: () {
            Get.to(const PageDetailChatScreen());
          }),
    );
  }
}
