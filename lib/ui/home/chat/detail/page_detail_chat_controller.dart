
import 'dart:convert';
import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:get/get.dart';

import '../../../../model/user.dart';
import '../../../../util/shared_preferences_util.dart';

class PageDetailChatController extends BaseController {
  final CollectionReference _users = FirebaseFirestore.instance.collection('users');

  var userData = UserData().obs;
  var userChat = const User(id: "").obs;
  var messages = <Message>[].obs;

  Future<void> getData() async {
    var currentUid = await SharedPreferencesUtil.getUIDLogin() ?? "";
    _getUserInfo(currentUid);
    _fetchMessages();
  }

  Future<void> _getUserInfo(String uid) async {
    try {
      _users.doc(uid).snapshots().listen((value) {
        DocumentSnapshot<Map<String, dynamic>>? userMap =
        value as DocumentSnapshot<Map<String, dynamic>>?;
        if (userMap == null || userMap.data() == null) return;

        var user = UserData.fromJson((userMap).data()!);
        userData.value = user;
        userChat.value = User(
          id: user.uid ?? "",
          lastName: user.name ?? "",
          imageUrl: user.avatar ?? "",
        );
        log("getUserInfo success: ${user.toString()}");
      });
    } catch (e) {
      log("getUserInfo get user info fail: $e");
    }
  }

    Future<void> _fetchMessages() async {
    final response = await rootBundle.loadString('assets/files/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => Message.fromJson(e as Map<String, dynamic>))
        .toList();
    this.messages.value = messages;
  }

  void addMessage(Message message) {
    messages.insert(0, message);
  }

  void clearOnDispose() {
    Get.delete<PageDetailChatController>();
  }
}