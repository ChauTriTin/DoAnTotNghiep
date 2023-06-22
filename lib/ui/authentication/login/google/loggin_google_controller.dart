import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/const/string_constants.dart';
import '../../../../model/gender.dart';
import '../../../../model/user.dart';
import '../../../../util/shared_preferences_util.dart';
import '../../../../util/ui_utils.dart';
import '../../../home/home_screen.dart';

class LoginGoogleController extends BaseController {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  var userData = UserData().obs;
  var genders = <Gender>[].obs;

  void clearOnDispose() {
    Get.delete<LoginGoogleController>();
  }

  void getData() {
    initGender();
  }

  void updateGender(int index) {
    for (var gender in genders) {
      gender.isSelected = false;
    }
    genders[index].isSelected = true;

    userData.value.gender = index + 1;
  }

  void initGender() {
    genders.add(
        Gender(StringConstants.male, Icons.male, userData.value.gender == 1));
    genders.add(Gender(
        StringConstants.female, Icons.female, userData.value.gender == 2));
    genders.add(Gender(
        StringConstants.other, Icons.transgender, userData.value.gender == 3));
  }

  Future<void> saveUserToFirebase() async {
    setAppLoading(true, "Loading", TypeApp.login);
    log('saveUserInfoToFirebaseDataStore: user: ${userData.value.toJson()}');
    _users
        .doc(userData.value.uid)
        .set(userData.value.toJson())
        .then((value) => {
              log("saveUserInfoToFirebaseDataStore User Added"),
              UIUtils.showSnackBar(
                  StringConstants.signin, StringConstants.signInSuccess),
              SharedPreferencesUtil.setUID(userData.value.uid ?? ""),

              //
              setAppLoading(false, "Loading", TypeApp.login),
              Get.offAll(const HomeScreen()),
            })
        .catchError((error) => {
              log("saveUserInfoToFirebaseDataStore Failed to add user: $error"),
              setAppLoading(false, "Loading", TypeApp.login),
            });
  }
}
