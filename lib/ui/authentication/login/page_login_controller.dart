import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/form.dart';
import 'package:get/get.dart';

import '../../../base/base_controller.dart';
import '../../../common/const/string_constants.dart';
import '../../../util/log_dog_utils.dart';
import '../../../util/shared_preferences_util.dart';
import '../../../util/ui_utils.dart';
import '../../home/home_screen.dart';

class ControllerLogin extends BaseController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var email = "".obs;
  var password = "".obs;

  void clearOnDispose() {
    Get.delete<ControllerLogin>();
  }

  void setEmail(String? id) {
    email.value = id ?? "";
  }

  String getEmail() {
    return email.value ?? "";
  }

  void setPassword(String? pw) {
    password.value = pw ?? "";
  }

  void doLogin() {
    Dog.d("doLogin: email:${email.value}, password: ${password.value}}");
    signInWithEmailAndPassword();
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      var emailStr = email.value;
      setAppLoading(true, "Loading", TypeApp.login);

      if (!(await isEmailExist(emailStr))) {
        Dog.d("Login fail. Email does not exist");
        setAppLoading(false, "Loading", TypeApp.login);
        loginFail(null);
        return;
      }

      final UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: emailStr,
        password: password.value,
      );
      final User? user = userCredential.user;

      if (user != null) {
        setAppLoading(false, "Loading", TypeApp.login);

        Dog.d("signInWithEmailAndPassword: SignIn successfully ${user.toString()}");
        UIUtils.showSnackBar(StringConstants.signin, StringConstants.signInSuccess);

        SharedPreferencesUtil.setUID(user.uid);
        Get.offAll(const HomeScreen());
      }
    } catch (e) {
      Dog.d("signInWithEmailAndPassword: SignIn failed $e");
      loginFail(e);
    }
  }

  Future<bool> isEmailExist(String email) async {
    List<String> signInMethods = await auth.fetchSignInMethodsForEmail(email);
    return signInMethods.isNotEmpty;
  }

  void loginFail(Object? e) {
    setAppLoading(false, "Loading", TypeApp.login);

    String errorMsg = "";
    if (e == null) {
      errorMsg = StringConstants.emailNotFound;
    } else {
      errorMsg = StringConstants.loginFailWithError;
    }

    UIUtils.showSnackBarError(StringConstants.error, errorMsg);
    log("Reset password fail: $e");
  }
}
