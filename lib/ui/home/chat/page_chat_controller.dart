import 'package:appdiphuot/base/base_controller.dart';
import 'package:get/get.dart';

class PageChatController extends BaseController {
  var conversationList = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  void clearOnDispose() {
    Get.delete<PageChatController>();
  }
}
