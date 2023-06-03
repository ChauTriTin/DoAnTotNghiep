import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends BaseController {
  final _auth = FirebaseAuth.instance;
  var email = "".obs;

  void clearOnDispose() {
    Get.delete<ForgotPasswordController>();
  }

  void setEmail(String id) {
    email.value = id;
  }

  String getEmail() {
    return email.value;
  }

  Future<void> resetPassword() async {
    var email = getEmail();
    log("Reset password: email: $email");
    if (email.isNotEmpty) {
      setAppLoading(true, "Loading", TypeApp.forgotPassword);

      try {
        if (await isEmailExist(email)) {
          await _auth
              .sendPasswordResetEmail(email: email)
              .then((value) => {
                    setAppLoading(false, "Loading", TypeApp.forgotPassword),
                    UIUtils.showSnackBar(StringConstants.resetPw, StringConstants.resetPwSuccess),
                    log("Reset password success"),
                  })
              .catchError((e) => {resetPasswordFail(e)});
        } else {
          resetPasswordFail(null);
        }
      } catch (e) {
        resetPasswordFail(e);
      }
    }
  }

  Future<bool> isEmailExist(String email) async {
    List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);
    return signInMethods.isNotEmpty;
  }

  void resetPasswordFail(Object? e) {
    setAppLoading(false, "Loading", TypeApp.forgotPassword);

    String errorMsg = "";
    if (e == null) {
      errorMsg = StringConstants.emailNotFound;
    } else {
      errorMsg = StringConstants.resetPwFail + errorMsg;
    }

    UIUtils.showSnackBarError(StringConstants.error, errorMsg);
    log("Reset password fail: $e");
  }
}