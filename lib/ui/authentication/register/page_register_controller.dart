import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/authentication/landing_page/page_authentication_screen.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../util/log_dog_utils.dart';
import '../../../util/shared_preferences_util.dart';
import '../../../util/ui_utils.dart';
import '../../home/home_screen.dart';

class RegisterController extends BaseController {
  final FirebaseAuth auth = FirebaseAuth.instance;

  var name = "".obs;
  var email = "".obs;
  var password = "".obs;
  var confirmPassword = "".obs;

  void clearOnDispose() {
    Get.delete<RegisterController>();
  }

  void setName(String value) {
    name.value = value;
  }

  void setEmail(String value) {
    email.value = value;
  }

  void setPassword(String value) {
    Dog.d("setPassword: $value");
    password.value = value;
  }

  String getPw() {
    return password.value;
  }

  String getConfirmPw() {
    return confirmPassword.value ?? "";
  }

  void setConfirmPassword(String value) {
    Dog.d("setConfirmPassword: $value");
    confirmPassword.value = value;
  }

  void doRegister() {
    Dog.d(
        "doRegister: name: ${name.value}, email:${email.value}, password: ${password.value}, confirmPw: ${confirmPassword.value}");
    signUpWithEmailAndPassword();
  }

  Future<void> signUpWithEmailAndPassword() async {
    try {
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
              email: email.value, password: password.value);
      final User? user = userCredential.user;

      if (user != null) {
        Dog.d("signUpWithEmailAndPassword: Signup success ${user.toString()}");

        UIUtils.showSnackBar(
            StringConstants.register, StringConstants.signUpSuccess);
        Get.offAll(const AuthenticationScreen());
      }
    } catch (e) {
      Dog.d("signUpWithEmailAndPassword: Login failed $e");
    }
  }
}
