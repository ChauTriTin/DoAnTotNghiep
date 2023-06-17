
import 'package:appdiphuot/base/base_controller.dart';
import 'package:get/get.dart';

class SettingController extends BaseController{

  void clearOnDispose(){
    Get.delete<SettingController>();
  }
}