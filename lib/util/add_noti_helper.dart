import '../db/firebase_helper.dart';
import '../model/push_notification.dart';
import 'log_dog_utils.dart';

class AddNotificationHelper {
  static Future<void> addNotification(
      PushNotification noti, String userId) async {
    var notificationCollection = FirebaseHelper.collectionReferenceNotification;
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
