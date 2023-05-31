import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/ui/login/register/page_register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/base_stateful_state.dart';
import '../../../common/const/color_constants.dart';
import '../../../common/const/string_constants.dart';
import '../../../util/ui_utils.dart';
import '../login/page_login_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthenticationScreen();
  }
}

class _AuthenticationScreen extends BaseStatefulState<AuthenticationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        body: SafeArea(
          child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon back with circle
                  _buildLogoAuthWidget(),

                  // Title: Cùng bạn trên mọi hành trình
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    margin: const EdgeInsets.all(
                        DimenConstants.marginPaddingLarge),
                    child: UIUtils.getTextHeaderAuth(
                        StringConstants.titleAuthPage,
                        ColorConstants.colorBlack),
                  ),

                  // Sign in, register button
                  _buildButtonAreaWidget()
                ],
              )),
        ));
  }

  Expanded _buildButtonAreaWidget() {
    return Expanded(
        child: Container(
      decoration: UIUtils.getBoxDecorationLoginBg(),
      width: double.infinity,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          UIUtils.getLoginOutlineButton(
            StringConstants.signin,
            _navigateToLoginScreen,
          ),
          const SizedBox(
            height: DimenConstants.marginPaddingMedium,
          ),
          UIUtils.getLoginOutlineButton(
            StringConstants.register,
            _navigateToRegisterScreen,
          ),
        ],
      ),
    ));
  }

  Widget _buildLogoAuthWidget() {
    return Expanded(
      child: CircleAvatar(
        radius: DimenConstants.logoHeight,
        backgroundColor: ColorConstants.colorGrey,
        child: Padding(
          padding: const EdgeInsets.all(DimenConstants.logoStroke),
          // Border radius
          child: ClipOval(
              child: Image.asset(
            "assets/images/ic_launcher.png",
          )),
        ),
      ),
    );
  }

  void _navigateToLoginScreen() {
    Get.to(const LoginScreen());
  }

  void _navigateToRegisterScreen() {
    Get.to(const RegisterScreen());
  }
}
