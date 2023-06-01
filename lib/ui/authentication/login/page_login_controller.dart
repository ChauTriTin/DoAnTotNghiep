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
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );
      final User? user = userCredential.user;

      if (user != null) {
        Dog.d(
            "signInWithEmailAndPassword: SignIn successfully ${user.toString()}");
        UIUtils.showSnackBar(
            StringConstants.signin, StringConstants.signInSuccess);
        SharedPreferencesUtil.setUID(user.uid);
        Get.offAll(const HomeScreen());
      }
    } catch (e) {
      Dog.d("signInWithEmailAndPassword: SignIn failed $e");
    }
  }
}
