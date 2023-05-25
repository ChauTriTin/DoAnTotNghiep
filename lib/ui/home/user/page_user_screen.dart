import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/home/chat/page_chat_controller.dart';
import 'package:appdiphuot/ui/home/noti/page_noti_controller.dart';
import 'package:appdiphuot/ui/home/user/page_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      body: Container(
        color: Colors.cyan,
        padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
        child: Obx(() {
          var number = _controller.number.value;
          var list = _controller.list.toString();
          return ListView(
            children: [
              const Text(
                "This is Chat Page",
                style: TextStyle(
                  fontSize: DimenConstants.txtLarge,
                  color: Colors.white,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(240, 50),
                ),
                onPressed: () {
                  _controller.addNumber();
                  _controller.addString();
                },
                child: const Text(
                  '+',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.red,
                  ),
                ),
              ),
              Text("Number $number"),
              const SizedBox(height: DimenConstants.marginPaddingMedium),
              Text("list $list"),
              const SizedBox(height: DimenConstants.marginPaddingMedium),
            ],
          );
        }),
      ),
    );
  }
}
