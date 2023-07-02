import 'dart:convert';
import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/model/trip.dart';
import 'package:appdiphuot/ui/user_singleton_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:get/get.dart';

import '../../../../db/firebase_helper.dart';
import '../../../../util/log_dog_utils.dart';
import '../../../../util/shared_preferences_util.dart';

class PageDetailChatController extends BaseController {
  final CollectionReference _chat = FirebaseHelper.collectionReferenceChat;

  var tripData = Trip().obs;
  var userChat = const User(id: "").obs;
  var messages = <Message>[].obs;

  bool isCurrentUserJoinedTrip() {
    return tripData.value.listIdMember?.contains(userChat.value.id) ?? false;
  }

  Future<void> getData() async {
    var currentUid = await SharedPreferencesUtil.getUIDLogin() ?? "";
    _getUserData(currentUid);
    _fetchMessages(tripData.value.id);
    getDetailTrip();
  }

  Future<void> getDetailTrip() async {
    try {
      FirebaseHelper.collectionReferenceRouter
          .doc(tripData.value.id)
          .snapshots()
          .listen((value) {
        DocumentSnapshot<Map<String, dynamic>>? tripMap =
            value as DocumentSnapshot<Map<String, dynamic>>?;
        if (tripMap == null || tripMap.data() == null) return;

        var trip = Trip.fromJson((tripMap).data()!);
        tripData.value = trip;
        log("getTripDetail success: ${trip.toString()}");
      });
    } catch (e) {
      log("getTripDetail get user info fail: $e");
    }
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
    Dog.d("_fetchMessages: tripID: ${tripId.toString()}");

    var chatStream =
        _chat.doc(tripId).collection(FirebaseHelper.messages).snapshots();

    var chatSnapshots = chatStream.map((querySnapshot) => querySnapshot.docs);

    chatSnapshots.listen((chatSnapshots) {
      log("_fetchMessages: Update message");
      var tempMessages = <Message>[];

      for (var chatSnapshot in chatSnapshots) {

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
      Dog.d("_addMessageToFireStore: ${tripData.value.id}");
      await _chat
          .doc(tripData.value.id)
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
