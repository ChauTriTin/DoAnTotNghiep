import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/model/push_notification.dart';
import 'package:appdiphuot/util/log_dog_utils.dart';
import 'package:appdiphuot/util/shared_preferences_util.dart';
import 'package:get/get.dart';

class PageNotiController extends BaseController {
  var listNotification = <PushNotification>[].obs;

  void clearOnDispose() {
    Get.delete<PageNotiController>();
  }

  void getListNotification() {
    setAppLoading(true, "Loading", TypeApp.getListPushNotification);
    Dog.e(">>>getListNotification");
    listNotification.clear();
    var list = SharedPreferencesUtil.getListNotification(
        SharedPreferencesUtil.KEY_LIST_NOTI);

    list.then((value) {
      for (var element in value) {
        Dog.e(
            ">>>getListNotification element ${element.title}~${element.body}");
      }

      listNotification.addAll(value);
      listNotification.refresh();
      setAppLoading(false, "Loading", TypeApp.getListPushNotification);
      Dog.e(">>>getListNotification done ${listNotification.length}");
    });
  }
}
