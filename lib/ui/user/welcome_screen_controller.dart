import 'package:get/get.dart';

import '../../base/base_controller.dart';

class WelcomeController extends BaseController {
  void clearOnDispose() {
    Get.delete<WelcomeController>();
  }
}
