import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base/base_stateful_state.dart';
import '../../common/const/string_constants.dart';
import '../../util/shared_preferences_util.dart';
import '../login/page_login_screen.dart';
import '../user/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends BaseStatefulState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkIsLogin();
  }

  void _checkIsLogin() async {
    bool isLoggedIn = await SharedPreferencesUtil.isLoggedIn();

    if (isLoggedIn) {
      Get.off(const WelcomeScreen(title: StringConstants.appName));
    } else {
      Get.off(const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/splash.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
      child: const Center(
          //     child: Image.asset(
          //   "assets/images/ic_launcher.png",
          //   width: DimenConstants.splashIconSize,
          //   height: DimenConstants.splashIconSize,
          // )
          ),
    ));
  }
}
