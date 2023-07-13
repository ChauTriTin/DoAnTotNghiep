import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/authentication/login/page_login_controller.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:appdiphuot/util/validate_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../../../base/base_stateful_state.dart';
import '../../../util/PasswordField.dart';
import '../../../util/TextInputField.dart';
import '../forgot/page_forget_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends BaseStatefulState<LoginScreen> {
  final _formLoginKey = GlobalKey<FormState>();
  ControllerLogin loginController = Get.put(ControllerLogin());

  @override
  void initState() {
    super.initState();
    _setupListen();
  }

  void _setupListen() {
    loginController.appLoading.listen((appLoading) {
      if (appLoading.isLoading) {
        OverlayLoadingProgress.start(context, barrierDismissible: false);
      } else {
        OverlayLoadingProgress.stop();
      }
    });
    loginController.appError.listen((err) {
      showErrorDialog(StringConstants.errorMsg, err.messageError, "Retry", () {
        //do sth
      });
    });
  }

  @override
  void dispose() {
    loginController.clearOnDispose();
    OverlayLoadingProgress.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.colorWhite, body: _buildBody());
  }

  Widget _buildBody() {
    return SafeArea(
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
    );
  }

  Widget _buildLoginWidget() {
    return Expanded(
        flex: 5,
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: DimenConstants.marginPaddingLarge),
          decoration: UIUtils.getBoxDecorationLoginBg(),
          width: double.infinity,
          child: SingleChildScrollView(
              child: Form(
                  key: _formLoginKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title: Sign in
                      const SizedBox(height: DimenConstants.marginPaddingLarge),
                      UIUtils.getTextHeaderAuth(
                          StringConstants.signin, ColorConstants.colorWhite),
                      const SizedBox(height: DimenConstants.marginPaddingLarge),

                      //Email
                      UIUtils.getTitleTextInputAuth(StringConstants.email),
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      _getEmailTextInputWidget(),
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

                      // Google - Facebook
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Google
                          GestureDetector(
                            onTap: onTabGoogleLogin,
                            child: Container(
                                padding: const EdgeInsets.all(
                                    DimenConstants.marginPaddingTiny),
                                decoration: const BoxDecoration(
                                    color: ColorConstants.colorWhite,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            DimenConstants.radiusRound))),
                                width: DimenConstants.loginIconSize,
                                child: Image.asset(
                                  "assets/images/ic_google.png",
                                )),
                          ),

                          const SizedBox(
                              width: DimenConstants.marginPaddingLarge),

                          // // Facebook
                          // GestureDetector(
                          //   onTap: onTabFacebookLogin,
                          //   child: SizedBox(
                          //       width: DimenConstants.loginIconSize,
                          //       child: Image.asset(
                          //         "assets/images/ic_facebook.png",
                          //       )),
                          // )
                        ],
                      ),

                      const SizedBox(height: DimenConstants.marginPaddingLarge),
                    ],
                  ))),
        ));
  }

  void _doLogin() {
    _formLoginKey.currentState!.save();
    if (_formLoginKey.currentState!.validate()) {
      loginController.doLogin();
    }
  }

  void _navigateToForgotPasswordScreen() {
    Get.to(PageForgetPassword(email: loginController.email.value));
  }

  Widget _getPasswordWidget() {
    return PasswordField(
      validator: ValidateUtils.validatePassword,
      onChange: (String? value) {
        loginController.password.value = value ?? "";
      },
    );
  }

  Widget _getEmailTextInputWidget() {
    return TextInputField(
      validator: ValidateUtils.validateEmail,
      keyboardType: TextInputType.emailAddress,
      onChange: (String? value) {
        loginController.email.value = value ?? "";
      },
    );
  }

  void onTabGoogleLogin() {
    loginController.signInWithGoogle();
  }

  void onTabFacebookLogin() {
    UIUtils.showSnackBarError(
        StringConstants.error, StringConstants.facebookLoginError);
  }
}
