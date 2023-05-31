import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/form.dart';
import 'package:get/get.dart';

import '../../../base/base_controller.dart';
import '../../../util/log_dog_utils.dart';
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

  void setPassword(String? pw) {
    password.value = pw ?? "";
  }

  void doLogin() {
    Dog.d("doLogin: email:${email.value}, password: ${password.value}}");
    signInWithEmailAndPassword();
    // SharedPreferencesUtil.setUID("");
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      final UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );
      final User? user = userCredential.user;

      if (user != null) {
        Dog.d("signInWithEmailAndPassword: SignIn successfully ${user.toString()}");
        Get.offAll(const HomeScreen());
      }
    } catch (e) {
      Dog.d("signInWithEmailAndPassword: SignIn failed $e");
    }
  }

  Future<void> signUpWithEmailAndPassword() async {
    try {
      final UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email.value,
          password: password.value
      );
      final User? user = userCredential.user;

      if (user != null) {
        Dog.d("signUpWithEmailAndPassword: Signup success ${user.toString()}");
        Get.offAll(const HomeScreen());
      }
    } catch (e) {
      Dog.d("signUpWithEmailAndPassword: Login failed $e");
    }
  }
}
