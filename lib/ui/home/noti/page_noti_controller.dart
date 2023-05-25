import 'package:appdiphuot/base/base_controller.dart';
import 'package:get/get.dart';

class PageNotiController extends BaseController {
  var number = 0.obs;
  var list = <String>[].obs;

  void clearOnDispose() {
    Get.delete<PageNotiController>();
  }

  void addNumber() {
    number.value++;
  }

  void addString() {
    list.add(DateTime.now().toString());
    list.refresh();
  }
}
