
import 'dart:convert';
import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/model/chat.dart';
import 'package:appdiphuot/model/trip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:get/get.dart';

import '../../../../db/firebase_helper.dart';
import '../../../../model/user.dart';
import '../../../../util/log_dog_utils.dart';
import '../../../../util/shared_preferences_util.dart';

class PageDetailChatController extends BaseController {
  final CollectionReference _users = FirebaseHelper.collectionReferenceUser;
  final CollectionReference _chat = FirebaseHelper.collectionReferenceChat;

  Trip? tripData;
  var userData = UserData().obs;
  var userChat = const User(id: "").obs;
  var messages = <Message>[].obs;

  Future<void> getData() async {
    var currentUid = await SharedPreferencesUtil.getUIDLogin() ?? "";
    _getUserInfo(currentUid);
    _fetchMessages(tripData?.id);
  }

  Future<void> _getUserInfo(String uid) async {
    try {
      _users.doc(uid).snapshots().listen((value) {
        DocumentSnapshot<Map<String, dynamic>>? userMap = value as DocumentSnapshot<Map<String, dynamic>>?;
        if (userMap == null || userMap.data() == null) return;

        var user = UserData.fromJson((userMap).data()!);
        userData.value = user;
        userChat.value = User(
          id: user.uid ?? "",
          firstName: user.name ?? "",
          imageUrl: user.avatar ?? "",
        );
        Dog.d("getUserInfo success: ${user.toString()}");
      });
    } catch (e) {
      Dog.e("getUserInfo get user info fail: $e");
    }
  }

    Future<void> _fetchMessages(String? tripId) async {
    if (tripId == null) return;
    _chat.doc(tripId).snapshots().listen((value) {
      DocumentSnapshot<Map<String, dynamic>>? chatMap = value as DocumentSnapshot<Map<String, dynamic>>?;
      if (chatMap == null || chatMap.data() == null) return;

      var chatData = Chat.fromJson(chatMap.data()!);
      messages.value = chatData.messages;
    });
  }

  void addMessage(Message message) async {
    messages.insert(0, message);
    await _addMessageToFireStore(message);
  }

  Future<void> _addMessageToFireStore(Message message) async {
    try {
      await _chat.doc(tripData?.id).update(Chat(messages).toJson());
    } catch (e) {
      Dog.e("_addMessageToFireStore fail: $e");
    }
  }

  void clearOnDispose() {
    Get.delete<PageDetailChatController>();
  }
}