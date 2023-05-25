import 'package:appdiphuot/base/base_controller.dart';
import 'package:get/get.dart';

class PageChatController extends BaseController {
  var number = 0.obs;
  var list = <String>[].obs;

  void clearOnDispose() {
    Get.delete<PageChatController>();
  }

  void addNumber() {
    number.value++;
  }

  void addString() {
    list.add(DateTime.now().toString());
    list.refresh();
  }
}
