import 'package:appdiphuot/base/base_controller.dart';
import 'package:get/get.dart';

import '../../../util/log_dog_utils.dart';

class RegisterController extends BaseController {
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
    password.value = value;
  }

  String getPw() {
    return password.value ?? "";
  }

  String getConfirmPw() {
    return confirmPassword.value ?? "";
  }

  void setConfirmPassword(String value) {
    confirmPassword.value = value;
  }

  void doRegister() {
    Dog.d(
        "doRegister: name: ${name.value}, email:${email.value}, password: ${password.value}, confirmPw: ${confirmPassword.value}");
  }
}
