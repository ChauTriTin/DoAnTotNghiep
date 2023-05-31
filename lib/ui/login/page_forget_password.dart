import 'dart:developer';

import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/const/color_constants.dart';
import '../../common/const/dimen_constants.dart';
import '../../common/const/string_constants.dart';
import '../../util/ui_utils.dart';

class PageForgetPassword extends StatefulWidget {
  const PageForgetPassword({Key? key}) : super(key: key);

  @override
  State<PageForgetPassword> createState() => _PageForgetPasswordState();
}

class _PageForgetPasswordState extends BaseStatefulState<PageForgetPassword> {
  final _auth = FirebaseAuth.instance;

  Future<void> _resetPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email).then((value) => log('data')).catchError((e) => log('data Error: $e'));
  }

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: DimenConstants.marginPaddingLarge),
                    UIUtils.getTextHeaderAuth(StringConstants.forgotPW, ColorConstants.colorWhite),
                    const SizedBox(height: DimenConstants.marginPaddingLarge),

                    //Email
                    UIUtils.getTitleTextInputAuth(StringConstants.email),
                    const SizedBox(height: DimenConstants.marginPaddingSmall),
                    UIUtils.getTextInputLogin(null, TextInputType.emailAddress),
                    const SizedBox(height: DimenConstants.marginPaddingMedium),

                    // Forgot pw btn
                    const SizedBox(height: DimenConstants.marginPaddingExtraLarge),
                    UIUtils.getLoginOutlineButton(
                      StringConstants.forgotPW,
                      () => _resetPassword(email: "huynhquocnguyen99@gmail.com"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
