import 'package:appdiphuot/base/base_controller.dart';
import 'package:get/get.dart';

class RateController extends BaseController {
  void clearOnDispose() {
    Get.delete<RateController>();
  }
}
