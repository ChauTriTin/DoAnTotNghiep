import 'dart:developer';

import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/ui/authentication/forgot/page_forget_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../../../common/const/color_constants.dart';
import '../../../common/const/dimen_constants.dart';
import '../../../common/const/string_constants.dart';
import '../../../util/TextInputField.dart';
import '../../../util/ui_utils.dart';
import '../../../util/validate_utils.dart';

class PageForgetPassword extends StatefulWidget {
  PageForgetPassword({
    super.key,
    this.email,
  });

  final String? email;

  @override
  State<PageForgetPassword> createState() => _PageForgetPasswordState();
}

class _PageForgetPasswordState extends BaseStatefulState<PageForgetPassword> {
  ForgotPasswordController controller = Get.put(ForgotPasswordController());
  final _formForgotPWKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _setupListen();
    controller.setEmail(widget.email ?? "");
    log("email forgot pw: ${widget.email}");
  }

  void _setupListen() {
    controller.appLoading.listen((appLoading) {
      if (appLoading.isLoading) {
        OverlayLoadingProgress.start(context, barrierDismissible: false);
      } else {
        OverlayLoadingProgress.stop();
      }
    });
    controller.appError.listen((err) {
      showErrorDialog(StringConstants.errorMsg, err.messageError, "Retry", () {
        //do sth
      });
    });
  }

  @override
  void dispose() {
    controller.clearOnDispose();
    OverlayLoadingProgress.stop();
    super.dispose();
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
                  _buildForgetPwWidget(),
                ],
              )),
        ));
  }

  Widget _buildForgetPwWidget() {
    return Expanded(
        flex: 5,
        child: Container(
          decoration: UIUtils.getBoxDecorationLoginBg(),
          width: double.infinity,
          child: ListView(
            children: [
              Form(
                key: _formForgotPWKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: DimenConstants.marginPaddingLarge),
                    UIUtils.getTextHeaderAuth(
                        StringConstants.forgotPW, ColorConstants.colorWhite),
                    const SizedBox(height: DimenConstants.marginPaddingLarge),

                    //Email
                    UIUtils.getTitleTextInputAuth(StringConstants.email),
                    const SizedBox(height: DimenConstants.marginPaddingSmall),
                    _getEmailTextInputWidget(),
                    const SizedBox(height: DimenConstants.marginPaddingMedium),

                    // Forgot pw btn
                    const SizedBox(
                        height: DimenConstants.marginPaddingExtraLarge),
                    UIUtils.getLoginOutlineButton(
                      StringConstants.forgotPW,
                      () => checkResetPw(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _getEmailTextInputWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: DimenConstants.marginPaddingExtraLarge),
      child: TextInputField(
        validator: _validateEmail,
        keyboardType: TextInputType.emailAddress,
        onChange: (String? value) {
          controller.setEmail(value ?? "");
        },
        initalText: controller.getEmail(),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value!.isEmpty) return StringConstants.errorEmailEmpty;
    if (!ValidateUtils.isValidEmailFormat(value)) {
      return StringConstants.errorEmailRegex;
    }
    return null;
  }

  void checkResetPw() {
    if (_formForgotPWKey.currentState!.validate()) {
      _formForgotPWKey.currentState!.save();
      controller.resetPassword();
    }
  }
}
