import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/util/shared_preferences_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../common/const/string_constants.dart';
import '../../model/user.dart';

class HomeController extends BaseController {
  var userData = UserData().obs;

  void clearOnDispose() {
    Get.delete<HomeController>();
  }
}
