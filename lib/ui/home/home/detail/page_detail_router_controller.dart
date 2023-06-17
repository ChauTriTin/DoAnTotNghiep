import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../common/const/string_constants.dart';
import '../../../../model/user.dart';

class DetailRouterController extends BaseController {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

}
