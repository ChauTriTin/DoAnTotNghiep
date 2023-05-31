import 'package:appdiphuot/ui/user/welcome_screen.dart';
import 'package:get/get.dart';

import '../../../base/base_controller.dart';
import '../../../util/log_dog_utils.dart';

class ControllerLogin extends BaseController {
  var email = "".obs;
  var password = "".obs;

  void clearOnDispose() {
    Get.delete<ControllerLogin>();
  }

  void setEmail(String id) {
    email.value = id;
  }

  void setPassword(String pw) {
    password.value = pw;
  }

  void doLogin() {
    Dog.d("doLogin: email:${email.value}, password: ${password.value}");
    Get.offAll(const WelcomeScreen(title: ""));
  }
}
