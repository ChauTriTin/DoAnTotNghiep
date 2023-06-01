import 'package:appdiphuot/base/base_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../util/shared_preferences_util.dart';

class PageUserController extends BaseController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var number = 0.obs;
  var list = <String>[].obs;

  void clearOnDispose() {
    Get.delete<PageUserController>();
  }

  void addNumber() {
    number.value++;
  }

  void addString() {
    list.add(DateTime.now().toString());
    list.refresh();
  }

  void signOut() {
    setAppLoading(true, "Loading", TypeApp.logout);
    SharedPreferencesUtil.setUID("");
    auth.signOut();
    setAppLoading(false, "Loading", TypeApp.logout);
  }
}
