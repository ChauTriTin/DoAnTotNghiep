import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/ui/authentication/register/page_register_controller.dart';
import 'package:appdiphuot/util/log_dog_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/base_stateful_state.dart';
import '../../../common/const/string_constants.dart';
import '../../../util/PasswordField.dart';
import '../../../util/TextInputField.dart';
import '../../../util/ui_utils.dart';
import '../../../util/validate_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreen();
  }
}

class _RegisterScreen extends BaseStatefulState<RegisterScreen> {
  final _formLoginKey = GlobalKey<FormState>();
  RegisterController registerController = Get.put(RegisterController());

  @override
  void initState() {
    super.initState();
    _setupListen();
  }

  void _setupListen() {
    registerController.appLoading.listen((appLoading) {});
    registerController.appError.listen((err) {
      showErrorDialog(StringConstants.errorMsg, err.messageError, "Retry", () {
        //do sth
      });
    });
  }

  @override
  void dispose() {
    registerController.clearOnDispose();
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
              const SizedBox(height: DimenConstants.marginPaddingMedium),
              _buildLoginWidget()
            ],
          )),
    );
  }

  Widget _buildLoginWidget() {
    return Expanded(
        flex: 5,
        child: Container(
          decoration: UIUtils.getBoxDecorationLoginBg(),
          width: double.infinity,
          child: SingleChildScrollView(
              child: Form(
                  key: _formLoginKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title: Register
                      const SizedBox(height: DimenConstants.marginPaddingLarge),
                      UIUtils.getTextHeaderAuth(StringConstants.registerTitle,
                          ColorConstants.colorWhite),
                      const SizedBox(height: DimenConstants.marginPaddingLarge),

                      // Name
                      UIUtils.getTitleTextInputAuth(StringConstants.name),
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      _getTextInputWidget(false),
                      const SizedBox(
                          height: DimenConstants.marginPaddingMedium),

                      //Email
                      UIUtils.getTitleTextInputAuth(StringConstants.email),
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      _getTextInputWidget(true),
                      const SizedBox(
                          height: DimenConstants.marginPaddingMedium),

                      // Password
                      UIUtils.getTitleTextInputAuth(StringConstants.password),
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      _getPasswordWidget(false),
                      const SizedBox(
                          height: DimenConstants.marginPaddingMedium),

                      // Confirm password
                      UIUtils.getTitleTextInputAuth(
                          StringConstants.passwordConfirm),
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      _getPasswordWidget(true),
                      const SizedBox(
                          height: DimenConstants.marginPaddingMedium),

                      // Register btn
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      UIUtils.getLoginOutlineButton(
                        StringConstants.register,
                        _doRegister,
                      ),

                      const SizedBox(
                          height: DimenConstants.marginPaddingExtraLarge),
                    ],
                  ))),
        ));
  }

  void _doRegister() {
    _formLoginKey.currentState!.save();
    if (_formLoginKey.currentState!.validate()) {
      registerController.doRegister();
    }
  }

  Widget _getPasswordWidget(bool isConfirmPassword) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: DimenConstants.marginPaddingExtraLarge),
      child: PasswordField(
        validator: isConfirmPassword
            ? validatePasswordConfirm
            : ValidateUtils.validatePassword,
        onSaved: (String? value) {
          if (isConfirmPassword) {
            registerController.setConfirmPassword(value ?? "");
          } else {
            registerController.setPassword(value ?? "");
          }
        },
      ),
    );
  }

  String? validatePasswordConfirm(String? confirmPw) {
    if (confirmPw!.isEmpty) {
      return StringConstants.errorPasswordEmpty;
    }

    String? pw = registerController.getPw();

    Dog.d("pw: $pw, confirmPw: $confirmPw");
    if (!ValidateUtils.isValidPasswordRetype(pw, confirmPw)) {
      return StringConstants.errorPasswordNotMatch;
    }
    return null;
  }

  Widget _getTextInputWidget(bool isEmail) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: DimenConstants.marginPaddingExtraLarge),
      child: TextInputField(
        validator: isEmail
            ? ValidateUtils.validateEmail
            : ValidateUtils.validateUserName,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        onSaved: (String? value) {
          if (isEmail) {
            registerController.setEmail(value ?? "");
          } else {
            registerController.setName(value ?? "");
          }
        },
      ),
    );
  }
}
