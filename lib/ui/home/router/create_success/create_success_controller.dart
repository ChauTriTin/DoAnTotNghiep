import 'package:appdiphuot/base/base_controller.dart';
import 'package:get/get.dart';

class CreateSuccessController extends BaseController {
  var isDoneCountdown = false.obs;

  void clearOnDispose() {
    Get.delete<CreateSuccessController>();
  }

  void setDoneCountdown(bool value) {
    isDoneCountdown.value = value;
  }
}
