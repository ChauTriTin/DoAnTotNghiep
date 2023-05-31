import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/base_stateful_state.dart';
import '../../../util/PasswordField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends BaseStatefulState<LoginScreen> {
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
  GlobalKey<FormFieldState<String>>();

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
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  UIUtils.getBackWidget(() {
                    Get.back();
                  }),
                  const SizedBox(height: DimenConstants.marginPaddingLarge),
                  _buildLoginWidget()
                ],
              )),
        ));
  }

  Widget _buildLoginWidget() {
    return Expanded(
        flex: 5,
        child: Container(
          decoration: UIUtils.getBoxDecorationLoginBg(),
          width: double.infinity,
          child: ListView(
            children: [
              Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: DimenConstants.marginPaddingLarge),
                      UIUtils.getTextHeaderAuth(StringConstants.signin, ColorConstants.colorWhite),
                      const SizedBox(height: DimenConstants.marginPaddingLarge),

                      //Email
                      UIUtils.getTitleTextInputAuth(StringConstants.email),
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      UIUtils.getTextInputLogin(
                          null, TextInputType.emailAddress),
                      const SizedBox(
                          height: DimenConstants.marginPaddingMedium),

                      // Password
                      UIUtils.getTitleTextInputAuth(StringConstants.password),
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      _getPasswordWidget(),
                      const SizedBox(
                          height: DimenConstants.marginPaddingMedium),

                      // Login btn
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      UIUtils.getLoginOutlineButton(
                        StringConstants.signin,
                        _doLogin,
                      ),

                      // Forgot pw
                      const SizedBox(height: DimenConstants.marginPaddingLarge),
                      TextButton(
                        onPressed: _navigateToForgotPasswordScreen,
                        child: const Text(
                          StringConstants.forgotPW,
                          style: TextStyle(
                              color: ColorConstants.textColorForgotPassword,
                              decoration: TextDecoration.underline),
                        ),
                      ),

                      // Other login ways
                      const Center(
                        child: Text(StringConstants.loginWayTitle,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: DimenConstants.txtLarge,
                            )),
                      ),
                      const SizedBox(
                          height: DimenConstants.marginPaddingMedium),

                      // Goole - Facebook
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Goolgle
                          CircleAvatar(
                            radius: DimenConstants.loginIconHeight,
                            backgroundColor: ColorConstants.colorGrey,
                            child: Padding(
                              padding:
                              const EdgeInsets.all(DimenConstants.logoStroke),
                              // Border radius
                              child: ClipOval(
                                  child: Image.asset(
                                    "assets/images/ic_launcher.png",
                                  )),
                            ),
                          ),

                          const SizedBox(
                              width: DimenConstants.marginPaddingLarge),

                          // Facebook
                          CircleAvatar(
                            radius: DimenConstants.loginIconHeight,
                            backgroundColor: ColorConstants.colorGrey,
                            child: Padding(
                              padding:
                              const EdgeInsets.all(DimenConstants.logoStroke),
                              // Border radius
                              child: ClipOval(
                                  child: Image.asset(
                                    "assets/images/ic_launcher.png",
                                  )),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: DimenConstants.marginPaddingLarge),
                    ],
                  ))
            ],
          ),
        ));
  }

  void _doLogin() {}

  void _navigateToForgotPasswordScreen() {}

  Widget _getPasswordWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: DimenConstants.marginPaddingExtraLarge),
      child: PasswordField(
        fieldKey: _passwordFieldKey,
        helperText: 'No more than 8 characters.',
        onFieldSubmitted: (String value) {
          setState(() {
            // this._password = value;
          });
        },
      ),
    );
  }
}
