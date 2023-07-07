import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/common/const/constants.dart';
import 'package:appdiphuot/db/firebase_helper.dart';
import 'package:appdiphuot/model/comment.dart';
import 'package:appdiphuot/util/log_dog_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_fcm_wrapper/flutter_fcm_wrapper.dart';
import 'package:get/get.dart';

import '../../../../common/const/string_constants.dart';
import '../../../../model/notification_data.dart';
import '../../../../model/push_notification.dart';
import '../../../../model/trip.dart';
import '../../../../model/user.dart';
import '../../../../util/add_noti_helper.dart';
import '../../../user_singleton_controller.dart';

class DetailRouterController extends BaseController {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  final routerCollection = FirebaseHelper.collectionReferenceRouter;
  final chatCollection = FirebaseHelper.collectionReferenceChat;
  var db = FirebaseFirestore.instance;

  var listTrips = <Trip>[].obs;

  var userLeaderData = UserData().obs;

  var userData = UserSingletonController.instance.userData;

  var detailTrip = Trip().obs;

  var commentData = <Comment>[].obs;

  var isWidgetJoinedVisible = true.obs;
  var isTripDeleted = false.obs;

  var listMember = <UserData>[].obs;

  bool isUserHost() {
    return detailTrip.value.userIdHost == userData.value.uid;
  }

  bool isTripCompleted() {
    return detailTrip.value.isComplete ?? false;
  }

  void getData(String tripId) {
    getAllRouter();
    getDetailTrip(tripId);
  }

  bool isUserBlocked() {
    Dog.d("isUserBlocked");
    return detailTrip.value.listIdMemberBlocked?.contains(userData.value.uid) ??
        false;
  }

  bool isJoinedCurrentTrip() {
    return detailTrip.value.listIdMember?.contains(userData.value.uid) ?? false;
  }

  Future<void> getAllRouter() async {
    var routerSnapshot = db.collection("router").orderBy("id", descending: true).snapshots();
    routerSnapshot.listen((event) {
      try {
        for (var docSnapshot in event.docs) {
          var trip = Trip.fromJson(docSnapshot.data().cast<String, dynamic>());
          if (listTrips.firstWhereOrNull(
                  (element) => element.id == docSnapshot.id) ==
              null) {
            listTrips
                .add(Trip.fromJson(docSnapshot.data().cast<String, dynamic>()));
          } else {
            if (listTrips.firstWhereOrNull(
                    (element) => element.id == docSnapshot.id) ==
                trip) {
              var index =
                  listTrips.indexWhere((element) => element.id == trip.id);
              listTrips[index] = trip;
            }
          }
          Dog.d('getAllRouter listTrips ${listTrips.length}');
        }
      } catch (ex) {
        Dog.e('getAllRouter error ${ex}');
      }
    });
  }

  Future<void> getUserInfo(String uid) async {
    try {
      if (uid == "") return;
      _users.doc(uid).snapshots().listen((value) {
        DocumentSnapshot<Map<String, dynamic>>? userMap =
            value as DocumentSnapshot<Map<String, dynamic>>?;
        if (userMap == null || userMap.data() == null) return;

        var user = UserData.fromJson((userMap).data()!);
        Dog.d("userId : ${user.uid}");
        Dog.d("isContain : ${user.avatar}");
        userLeaderData.value = user;
        log("getUserInfo success: ${user.toString()}");
      });
    } catch (e) {
      log("getUserInfo get user info fail: $e");
    }
  }

  Future<void> getDetailTrip(String? id) async {
    try {
      routerCollection.doc(id).snapshots().listen((value) {
        if (!value.exists) {
          print('getDetailTrip trip does not exist.');
          isTripDeleted.value = true;
        }

        DocumentSnapshot<Map<String, dynamic>>? tripMap =
            value as DocumentSnapshot<Map<String, dynamic>>?;
        if (tripMap == null || tripMap.data() == null) return;

        var trip = Trip.fromJson((tripMap).data()!);
        detailTrip.value = trip;


        getUserInfo(trip.userIdHost ?? "");
        getCommentRoute(trip.id);

        if (detailTrip.value.listIdMember?.contains(userData.value.uid) ==
            true) {
          isWidgetJoinedVisible.value = true;
        } else {
          isWidgetJoinedVisible.value = false;
        }

        isTripDeleted.value = false;
        log("getTripDetail success: ${trip.toString()}");
        getAllMember();
      });
    } catch (e) {
      isTripDeleted.value = true;
      log("getTripDetail get user info fail: $e");
    }
  }

  Future<void> getAllMember() async {
    try {
      setAppLoading(true, "Loading", TypeApp.loadingData);
      if (detailTrip.value.listIdMember == null ||
          detailTrip.value.listIdMember?.isEmpty == true) return;
      var tempUserList = <UserData>[];
      for (var uid in detailTrip.value.listIdMember!) {
        DocumentSnapshot userSnapshot = await _users.doc(uid).get();
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

  int hasContainUserInListMember(UserData userData) {
    for (int i = 0; i < listMember.length; i++) {
      if (userData.uid == listMember[i].uid) {
        return i;
      }
    }
    return -1;
  }

  Future<void> getCommentRoute(String? id) async {
    try {
      if (id == null) return;
      var data = routerCollection.doc(id).snapshots();

      Dog.d("getCommentRoute id: $id");

      data.listen((event) {
        Dog.d("getCommentRoute: ${event.data()}");
        commentData.clear();
        commentData.addAll(Trip.fromJson(event.data() as Map<String, dynamic>)
            .comments as Iterable<Comment>);
        Dog.d("getCommentRoute: ${commentData.length}");
      });
    } catch (e) {
      Dog.e("getCommentRoute: $e");
    }
  }

  Future<void> addCommentRoute(String? id, String text) async {
    try {
      Dog.d("addCommentRoute id: $id");
      if (id == null || text.isEmpty) return;
      var listComment = commentData;
      listComment.add(Comment(
          DateTime.now().millisecondsSinceEpoch.toString(),
          userData.value.getAvatar(),
          userData.value.name ?? "",
          text, <Comment>[]));

      List<Map<String, dynamic>> commentsData =
          listComment.map((comment) => comment.toJson()).toList();

      routerCollection
          .doc(id)
          .update({"comments": commentsData})
          .then((value) => postFCM(text, NotificationData.TYPE_COMMENT))
          .catchError((error) => Dog.e("addCommentRoute error: $error"));
    } catch (e) {
      log("addCommentRoute: $e");
    }
  }

  Future<void> joinedRouter(String? code) async {
    try {
      var id = userData.value.uid;
      Dog.d("joinedRouter id :$id");
      var listMember = detailTrip.value.listIdMember;
      if (detailTrip.value.id != code || code == null) {
        Dog.e("detailRoute error: wrong code");
      } else {
        if (listMember?.contains(id) == false || listMember != null) {
          listMember?.add(id!);
          routerCollection
              .doc(detailTrip.value.id)
              .update({"listIdMember": listMember})
              .then((value) => {
                    isWidgetJoinedVisible.value = true,
                    postFCM("${userData.value.name} vừa tham gia chuyến đi.",
                        NotificationData.TYPE_JOIN_ROUTER),
                    Dog.d("joinedRouter success")
                  })
              .catchError((error) => {Dog.e("joinedRouter error: $error")});
        }
      }
    } catch (e) {
      Dog.e("joinedRouter: $e");
    }
  }

  Future<void> postFCM(String body, String type) async {
    FlutterFCMWrapper flutterFCMWrapper = const FlutterFCMWrapper(
      apiKey: Constants.apiKey,
      enableLog: true,
      enableServerRespondLog: true,
    );
    try {
      var listFcmToken = <String>[];
      var memberIdsSendNoti = <String>[];
      for (var element in listMember) {
        var fcmToken = element.fcmToken;
        if (fcmToken != null &&
            fcmToken.isNotEmpty &&
            fcmToken != userData.value.fcmToken) {
          listFcmToken.add(fcmToken);
          if (element.uid != null && element.uid!.isNotEmpty) {
            memberIdsSendNoti.add(element.uid!);
          }
        }
      }
      debugPrint("fcmToken listFcmToken ${listFcmToken.length}");

      var title = "";
      switch (type) {
        case NotificationData.TYPE_JOIN_ROUTER:
          title =
              "${userData.value.name} đã tham gia chuyến đi '${detailTrip.value.title}'";
          break;
        case NotificationData.TYPE_COMMENT:
          title =
              "${userData.value.name} đã bình luận mới trong chuyến đi '${detailTrip.value.title}'";
          break;
        case NotificationData.TYPE_EXIT_ROUTER:
          title =
              "${userData.value.name} đã rời khỏi chuyến đi '${detailTrip.value.title}'";
          break;
          case NotificationData.TYPE_DELETE_ROUTER:
          title =
              "${detailTrip.value.title} đã bị ${userData.value.name} xóa";
          break;
      }

      PushNotification notification = PushNotification(
        title: title,
        body: body,
        dataTitle: null,
        dataBody: body,
        tripName: detailTrip.value.title,
        tripID: detailTrip.value.id,
        userName: userData.value.name,
        userAvatar: userData.value.avatar,
        notificationType: type,
        time: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      for (var element in memberIdsSendNoti) {
        AddNotificationHelper.addNotification(notification, element);
      }

      Map<String, dynamic> result =
          await flutterFCMWrapper.sendMessageByTokenID(
        userRegistrationTokens: listFcmToken,
        title: title,
        body: body,
        androidChannelID: DateTime.now().microsecondsSinceEpoch.toString(),
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      );
      Dog.e("FCM sendTopicMessage fcmToken result $result");
    } catch (e) {
      Dog.e("FCM sendTopicMessage fcmToken $e");
    }
  }

  String getLeaderAvatar() {
    Dog.d("getLeaderAvatar: ${userLeaderData.value.avatar}");
    String avatarUrl = userLeaderData.value.avatar ?? "";
    if (avatarUrl.isEmpty) {
      return StringConstants.avatarImgDefault;
    } else {
      return avatarUrl;
    }
  }

  String getNameLeader() {
    String name = userLeaderData.value.name ?? "";
    if (name.isEmpty) {
      return "";
    } else {
      return name;
    }
  }

  Future<void> deleteRouter() async {
    try {
      setAppLoading(true, "Loading", TypeApp.loadingData);
      var tripID = detailTrip.value.id;
      await routerCollection.doc(tripID).delete();
      await chatCollection.doc(tripID).delete();

      setAppLoading(false, "Loading", TypeApp.loadingData);
      postFCM("${detailTrip.value.title} đã bị xóa", NotificationData.TYPE_DELETE_ROUTER);
      Get.back();
    } catch (e) {
      Dog.e("Delete router error: $e");
      setAppLoading(false, "Loading", TypeApp.loadingData);
    }
  }

  Future<void> outTrip() async {
    try {
      setAppLoading(true, "Loading", TypeApp.loadingData);
      var listIdMember = detailTrip.value.listIdMember;
      Dog.d("outTrip currentIdMember: ${listIdMember.toString()}");
      listIdMember?.remove(userData.value.uid);
      // Get the reference to the document you want to update
      DocumentReference documentRef =
          FirebaseHelper.collectionReferenceRouter.doc(detailTrip.value.id);

      // Dog.d("removeMember listIdMemberJson: $listIdMemberJson - ${tripData.value.id}");
      // Update the specific field
      documentRef
          .update({FirebaseHelper.listIdMember: listIdMember}).then((value) {
        Dog.d("outTrip success");
        postFCM("${userData.value.name} ${StringConstants.informOutRouter}",
            NotificationData.TYPE_EXIT_ROUTER);
        setAppLoading(false, "Loading", TypeApp.loadingData);
      }).catchError((error) {
        setAppLoading(false, "Loading", TypeApp.loadingData);
        Dog.e("outTrip error: $error");
      });
    } catch (e) {
      setAppLoading(false, "Loading", TypeApp.loadingData);
      Dog.e("outTrip error: $e");
    }
  }
}
