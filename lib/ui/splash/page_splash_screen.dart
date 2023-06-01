import 'package:appdiphuot/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base/base_stateful_state.dart';
import '../../common/const/string_constants.dart';
import '../../util/shared_preferences_util.dart';
import '../authentication/landing_page/page_authentication_screen.dart';
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
    String? uid = await SharedPreferencesUtil.getUIDLogin();

    if (uid?.isNotEmpty == true) {
      Get.off(const HomeScreen());
    } else {
      Get.off(const AuthenticationScreen());
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
