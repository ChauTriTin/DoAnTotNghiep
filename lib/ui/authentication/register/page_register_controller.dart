import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/authentication/landing_page/page_authentication_screen.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../model/user.dart';
import '../../../util/log_dog_utils.dart';

class RegisterController extends BaseController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  var name = "".obs;
  var email = "".obs;
  var password = "".obs;
  var confirmPassword = "".obs;

  void clearOnDispose() {
    Get.delete<RegisterController>();
  }

  void setName(String value) {
    name.value = value;
  }

  void setEmail(String value) {
    email.value = value;
  }

  void setPassword(String value) {
    Dog.d("setPassword: $value");
    password.value = value;
  }

  String getPw() {
    return password.value;
  }

  String getConfirmPw() {
    return confirmPassword.value ?? "";
  }

  void setConfirmPassword(String value) {
    Dog.d("setConfirmPassword: $value");
    confirmPassword.value = value;
  }

  void doRegister() {
    Dog.d(
        "doRegister: name: ${name.value}, email:${email.value}, password: ${password.value}, confirmPw: ${confirmPassword.value}");
    signUpWithEmailAndPassword();
  }

  Future<void> signUpWithEmailAndPassword() async {
    try {
      setAppLoading(true, "Loading", TypeApp.register);

      if (await isEmailExist(email.value)) {
        Dog.d("Register fail, email already exist");
        setAppLoading(false, "Loading", TypeApp.register);
        registerFail(null);
        return;
      }

      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: email.value, password: password.value);
      final User? user = userCredential.user;

      // Register success
      if (user != null) {
        setAppLoading(false, "Loading", TypeApp.register);
        Dog.d("signUpWithEmailAndPassword: Signup success ${user.toString()}");

        UIUtils.showSnackBar(
            StringConstants.register, StringConstants.signUpSuccess);
        Get.offAll(const AuthenticationScreen());

        saveUserInfoToFirebaseDataStore(user);
      } else {
        registerFail(null);
      }
    } catch (e) {
      setAppLoading(false, "Loading", TypeApp.register);
      Dog.d("signUpWithEmailAndPassword: Login failed $e");
      registerFail(e);
    }
  }

  Future<bool> isEmailExist(String email) async {
    List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);
    return signInMethods.isNotEmpty;
  }

  Future<void> saveUserInfoToFirebaseDataStore(User user) async {
    try {
      var userData =
          UserData(name.value, user.uid, email.value, "");

      log('saveUserInfoToFirebaseDataStore: user: ${userData.toJson()}');
      _users
          .doc(user.uid)
          .set(userData.toJson())
          .then((value) => log("saveUserInfoToFirebaseDataStore User Added"))
          .catchError((error) => log(
              "saveUserInfoToFirebaseDataStore Failed to add user: $error"));
    } catch (e) {
      log('saveUserInfoToFirebaseDataStore: Error saving user to Firestore: $e');
    }
  }

  void registerFail(Object? e) {
    setAppLoading(false, "Loading", TypeApp.register);

    String errorMsg = "";
    if (e == null) {
      errorMsg = StringConstants.emailExist;
    } else {
      errorMsg = StringConstants.registerError + errorMsg;
    }

    UIUtils.showSnackBarError(StringConstants.error, errorMsg);
    log("registerFail fail: $e");
  }
}
