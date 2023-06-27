import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/db/firebase_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../util/shared_preferences_util.dart';
import '../../authentication/landing_page/page_authentication_screen.dart';
import '../user/edit/edit_profile_page.dart';

class SettingController extends BaseController {
  var isDarkMode = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var selectedLanguage = "".obs;
  var languages = [StringConstants.vietnamese, StringConstants.english].obs;

  void clearOnDispose() {
    Get.delete<SettingController>();
  }

  void updateLanguage(String item) {
    selectedLanguage.value = item;
    SharedPreferencesUtil.setString(SharedPreferencesUtil.LANGUAGE, item);
  }

  void getData() {
    getDarkModeStatus();
    getSelectedLanguage();
  }

  Future<void> getDarkModeStatus() async {
    isDarkMode.value = false;
    var isDarkModeOn = await SharedPreferencesUtil.getBool(
        SharedPreferencesUtil.IS_DARK_MODE_ON) ??
        false;
    isDarkMode.value = isDarkModeOn;
  }

  void updateDarkModeStatus(bool isDarkMode) {
    SharedPreferencesUtil.setBool(
        SharedPreferencesUtil.IS_DARK_MODE_ON, isDarkMode);
    this.isDarkMode.value = isDarkMode;
  }

  void navigateToEditProfile() {
    Get.to(const PageEditProfile());
  }

  void signOut() {
    setAppLoading(true, "Loading", TypeApp.logout);
    SharedPreferencesUtil.setUID("");
    _auth.signOut();
    setAppLoading(false, "Loading", TypeApp.logout);
    Get.offAll(const AuthenticationScreen());
  }

  Future<void> getSelectedLanguage() async {
    selectedLanguage.value =
        await SharedPreferencesUtil.getString(SharedPreferencesUtil.LANGUAGE) ??
            StringConstants.vietnamese;
  }
}
