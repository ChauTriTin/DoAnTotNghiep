import 'package:appdiphuot/base/base_controller.dart';
import 'package:get/get.dart';

class PageHomeController extends BaseController {
  var number = 0.obs;
  var list = <String>[].obs;

  void clearOnDispose() {
    Get.delete<PageHomeController>();
  }

  void addNumber() {
    number.value++;
  }

  void addString() {
    list.add(DateTime.now().toString());
    list.refresh();
  }
}
