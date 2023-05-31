import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
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
    log("Reset password: email: ${getEmail()}");
    await _auth
        .sendPasswordResetEmail(email: getEmail())
        .then((value) => log('data'))
        .catchError((e) => log('data Error: $e'));
  }
}
