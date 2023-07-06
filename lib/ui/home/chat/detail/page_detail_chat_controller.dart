import 'dart:convert';
import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/model/trip.dart';
import 'package:appdiphuot/ui/user_singleton_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_fcm_wrapper/flutter_fcm_wrapper.dart';
import 'package:get/get.dart';

import '../../../../db/firebase_helper.dart';
import '../../../../model/user.dart';
import '../../../../util/log_dog_utils.dart';
import '../../../../util/shared_preferences_util.dart';

class PageDetailChatController extends BaseController {
  final CollectionReference _chat = FirebaseHelper.collectionReferenceChat;
  final userCollection = FirebaseHelper.collectionReferenceUser;

  var tripData = Trip().obs;
  var userChat = const User(id: "").obs;
  var messages = <Message>[].obs;
  var isTripDeleted = false.obs;
  var listMember = <UserData>[].obs;

  bool isCurrentUserJoinedTrip() {
    return tripData.value.listIdMember?.contains(userChat.value.id) ?? false;
  }

  Future<void> getData() async {
    var currentUid = await SharedPreferencesUtil.getUIDLogin() ?? "";
    _getUserData(currentUid);
    _fetchMessages(tripData.value.id);
    getDetailTrip();
  }

  Future<void> getAllMember() async {
    try {
      setAppLoading(true, "Loading", TypeApp.loadingData);
      if (tripData.value.listIdMember == null ||
          tripData.value.listIdMember?.isEmpty == true) return;
      var tempUserList = <UserData>[];
      for (var uid in tripData.value.listIdMember!) {
        DocumentSnapshot userSnapshot = await userCollection.doc(uid).get();
        if (!userSnapshot.exists) {
          continue;
        }

        DocumentSnapshot<Map<String, dynamic>>? userMap =
        userSnapshot as DocumentSnapshot<Map<String, dynamic>>?;
        if (userMap == null || userMap.data() == null) return;

        var user = UserData.fromJson((userMap).data()!);
        tempUserList.add(user);
        log("_getUserParticipated success: ${user.toString()}");
      }
      setAppLoading(false, "Loading", TypeApp.loadingData);
      listMember.value = tempUserList;
    } catch (e) {
      setAppLoading(false, "Loading", TypeApp.loadingData);
      log("_getUserParticipated get user info fail: $e");
    }
  }

  Future<void> getDetailTrip() async {
    try {
      FirebaseHelper.collectionReferenceRouter
          .doc(tripData.value.id)
          .snapshots()
          .listen((value) {
        if (!value.exists) {
          print('getDetailTrip trip does not exist.');
          isTripDeleted.value = true;
        }
        DocumentSnapshot<Map<String, dynamic>>? tripMap =
            value as DocumentSnapshot<Map<String, dynamic>>?;
        if (tripMap == null || tripMap.data() == null) return;

        var trip = Trip.fromJson((tripMap).data()!);
        tripData.value = trip;
        isTripDeleted.value = false;
        getAllMember();
        log("getTripDetail success: ${trip.toString()}");
      });
    } catch (e) {
      isTripDeleted.value = true;
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

  Future<void> postFCM(
      String body,
      ) async {
    // FlutterFCMWrapper flutterFCMWrapper = const FlutterFCMWrapper(
    //   apiKey: Constants.apiKey,
    //   enableLog: true,
    //   enableServerRespondLog: true,
    // );
    // try {
    //   var listFcmToken = <String>[];
    //   var memberIdsSendNoti = <String>[];
    //   for (var element in listMember) {
    //     var fcmToken = element.fcmToken;
    //     if (fcmToken == currentUserData.value.fcmToken) {
    //       //ignore my token
    //     } else {
    //       if (fcmToken != null && fcmToken.isNotEmpty) {
    //         listFcmToken.add(fcmToken);
    //         if (element.uid != null && element.uid!.isNotEmpty) {
    //           memberIdsSendNoti.add(element.uid!);
    //         }
    //       }
    //     }
    //   }
    //   debugPrint("fcmToken listFcmToken ${listFcmToken.toString()}");
    //
    //   NotificationData notificationData = NotificationData(
    //       trip.value.id,
    //       currentUserData.value.uid,
    //       "1",
    //       DateTime.now().millisecondsSinceEpoch.toString());
    //
    //   var title = "Thông báo khẩn cấp từ ${getCurrentUserName()}";
    //   PushNotification notification = PushNotification(
    //     title: title,
    //     body: body,
    //     dataTitle: null,
    //     dataBody: body,
    //     data: notificationData.toJson(),
    //   );
    //
    //   for (var element in memberIdsSendNoti) {
    //     AddNotificationHelper.addNotification(notification, element);
    //   }
    //
    //   Map<String, dynamic> result =
    //   await flutterFCMWrapper.sendMessageByTokenID(
    //     userRegistrationTokens: listFcmToken,
    //     title: title,
    //     body: body,
    //     data: notificationData.toJson(),
    //     androidChannelID: DateTime.now().microsecondsSinceEpoch.toString(),
    //     clickAction: "FLUTTER_NOTIFICATION_CLICK",
    //   );
    //   debugPrint("FCM sendTopicMessage fcmToken result $result");
    // } catch (e) {
    //   debugPrint("FCM sendTopicMessage fcmToken $e");
    // }
  }

  void clearOnDispose() {
    Get.delete<PageDetailChatController>();
  }
}
