import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/db/firebase_helper.dart';
import 'package:appdiphuot/model/push_notification.dart';
import 'package:appdiphuot/util/log_dog_utils.dart';
import 'package:appdiphuot/util/shared_preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class NotificationController extends BaseController {
  static NotificationController? _instance;

  var notificationCollection = FirebaseHelper.collectionReferenceNotification;
  var notificationsData = <PushNotification>[].obs;

  static NotificationController get instance {
    _instance ??= NotificationController._();
    return _instance!;
  }

  NotificationController._();

  void clearOnDispose() {
    Get.delete<NotificationController>();
  }

  Future<void> addNotification(PushNotification noti) async {
    String userId =
        await SharedPreferencesUtil.getString(SharedPreferencesUtil.USER_UID) ??
            "";

    try {
      Dog.d("setNotification: $noti");
      await notificationCollection
          .doc(userId)
          .collection(FirebaseHelper.keyNotification)
          .doc()
          .set(noti.toJson());
    } catch (e) {
      Dog.e("_addMessageToFireStore fail: $e");
    }
  }
}
