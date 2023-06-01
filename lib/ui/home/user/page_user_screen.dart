import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/authentication/login/page_login_screen.dart';
import 'package:appdiphuot/ui/home/user/page_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

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
      backgroundColor: ColorConstants.appColorBkg,
      body: Container(
          color: ColorConstants.colorWhite,
          padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
          child: SingleChildScrollView(
            child: TextButton(
              onPressed: _signOut,
              child: const Text(StringConstants.signOut),
            ),
          )),
    );
  }

  void _signOut() {
    _controller.signOut();
    Get.offAll(const LoginScreen());
  }
}
