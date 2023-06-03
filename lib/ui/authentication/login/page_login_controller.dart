import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/form.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../base/base_controller.dart';
import '../../../common/const/string_constants.dart';
import '../../../model/user.dart';
import '../../../util/log_dog_utils.dart';
import '../../../util/shared_preferences_util.dart';
import '../../../util/ui_utils.dart';
import '../../home/home_screen.dart';

class ControllerLogin extends BaseController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final CollectionReference _users = FirebaseFirestore.instance.collection('users');
  var email = "".obs;
  var password = "".obs;

  void clearOnDispose() {
    Get.delete<ControllerLogin>();
  }

  void setEmail(String? id) {
    email.value = id ?? "";
  }

  String getEmail() {
    return email.value ?? "";
  }

  void setPassword(String? pw) {
    password.value = pw ?? "";
  }

  void doLogin() {
    Dog.d("doLogin: email:${email.value}, password: ${password.value}}");
    signInWithEmailAndPassword();
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      var emailStr = email.value;
      setAppLoading(true, "Loading", TypeApp.login);

      if (!(await isEmailExist(emailStr))) {
        Dog.d("Login fail. Email does not exist");
        setAppLoading(false, "Loading", TypeApp.login);
        loginFail(null);
        return;
      }

      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailStr,
        password: password.value,
      );
      final User? user = userCredential.user;

      if (user != null) {
        setAppLoading(false, "Loading", TypeApp.login);

        Dog.d("signInWithEmailAndPassword: SignIn successfully ${user.toString()}");
        UIUtils.showSnackBar(StringConstants.signin, StringConstants.signInSuccess);

        SharedPreferencesUtil.setUID(user.uid);
        Get.offAll(const HomeScreen());
      }
    } catch (e) {
      Dog.d("signInWithEmailAndPassword: SignIn failed $e");
      loginFail(e);
    }
  }

  Future<bool> isEmailExist(String email) async {
    List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);
    return signInMethods.isNotEmpty;
  }

  void loginFail(Object? e) {
    setAppLoading(false, "Loading", TypeApp.login);

    String errorMsg = "";
    if (e == null) {
      errorMsg = StringConstants.emailNotFound;
    } else {
      errorMsg = StringConstants.loginFailWithError;
    }

    UIUtils.showSnackBarError(StringConstants.error, errorMsg);
    log("Reset password fail: $e");
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        Dog.d("signInWithGoogle: SignIn successfully ${user.toString()}");
        UIUtils.showSnackBar(StringConstants.signin, StringConstants.signInSuccess);

        SharedPreferencesUtil.setUID(user.uid);
        saveUserInfoToFirebaseDataStore(user);

        setAppLoading(false, "Loading", TypeApp.login);
        Get.offAll(const HomeScreen());
      }
    } catch (e) {
      Dog.d("signInWithGoogle: SignIn failed $e");
      UIUtils.showSnackBarError(StringConstants.error, "Login fail: $e");
    }
  }

  Future<void> saveUserInfoToFirebaseDataStore(User user) async {
    try {
      var userData = UserData(user.displayName ?? "", user.uid, user.email ?? "", user.photoURL ?? "");

      log('saveUserInfoToFirebaseDataStore: user: ${userData.toJson()}');
      _users
          .doc(user.uid)
          .set(userData.toJson())
          .then((value) => log("saveUserInfoToFirebaseDataStore User Added"))
          .catchError((error) => log("saveUserInfoToFirebaseDataStore Failed to add user: $error"));
    } catch (e) {
      log('saveUserInfoToFirebaseDataStore: Error saving user to Firestore: $e');
    }
  }
}
