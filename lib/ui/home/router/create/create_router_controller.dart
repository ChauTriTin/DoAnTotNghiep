import 'package:appdiphuot/base/base_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CreateRouterController extends BaseController {
  var title = "".obs;
  var description = "".obs;
  var list = <String>[].obs;

  void clearOnDispose() {
    Get.delete<CreateRouterController>();
  }

  void setTitle(String s) {
    title.value = s;
  }

  void setDescription(String s) {
    description.value = s;
  }

  void createRouter() {
    String sTitle = title.value;
    String sDescription = description.value;

    // final images = controller.images;

    debugPrint(">>>createRouter sTitle $sTitle");
    debugPrint(">>>createRouter sDescription $sDescription");
  }
}
