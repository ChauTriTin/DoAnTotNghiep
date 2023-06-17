import 'dart:convert';
import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/model/chat.dart';
import 'package:appdiphuot/model/trip.dart';
import 'package:appdiphuot/ui/user_singleton_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:get/get.dart';

import '../../../../db/firebase_helper.dart';
import '../../../../util/log_dog_utils.dart';
import '../../../../util/shared_preferences_util.dart';

class PageDetailChatController extends BaseController {
  final CollectionReference _users = FirebaseHelper.collectionReferenceUser;
  final CollectionReference _chat = FirebaseHelper.collectionReferenceChat;

  Trip? tripData;
  var userChat = const User(id: "").obs;
  var messages = <Message>[].obs;

  Future<void> getData() async {
    var currentUid = await SharedPreferencesUtil.getUIDLogin() ?? "";
    _getUserData(currentUid);
    _fetchMessages(tripData?.id);
  }

  Future<void> _getUserData(String uid) async {
    var user = UserSingletonController.instance.userData.value;
    userChat.value = User(
      id: user.uid ?? "",
      firstName: user.name ?? "",
      imageUrl: user.avatar ?? "",
    );
  }

  Future<void> _fetchMessages(String? tripId) async {
    if (tripId == null) return;

    var chatStream = _chat.doc(tripId)
        .collection(FirebaseHelper.messages)
        .snapshots();

    var chatSnapshots = chatStream.map((querySnapshot) => querySnapshot.docs);

    chatSnapshots.listen((chatSnapshots) {
      var tempMessages = <Message>[];

      for (var chatSnapshot in chatSnapshots) {
        log("_fetchMessages: $chatSnapshot");

        DocumentSnapshot<Map<String, dynamic>>? message = chatSnapshot;

        if (message.data() == null) return;

        var trip = Message.fromJson((message).data()!);
        tempMessages.insert(0, trip);
      }

      messages.value = tempMessages;
    });
  }

  void addMessage(Message message) async {
    messages.insert(0, message);
    await _addMessageToFireStore(message);
  }

  Future<void> _addMessageToFireStore(Message message) async {
    try {
      var idMessage = DateTime.now().millisecondsSinceEpoch.toString();
      await _chat.doc(tripData?.id)
          .collection(FirebaseHelper.messages)
          .doc(message.createdAt.toString())
          .set(message.toJson());
    } catch (e) {
      Dog.e("_addMessageToFireStore fail: $e");
    }
  }

  void clearOnDispose() {
    Get.delete<PageDetailChatController>();
  }
}
