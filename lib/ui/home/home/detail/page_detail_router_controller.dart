import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/db/firebase_helper.dart';
import 'package:appdiphuot/model/comment.dart';
import 'package:appdiphuot/util/log_dog_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fcm_wrapper/flutter_fcm_wrapper.dart';
import 'package:get/get.dart';

import '../../../../common/const/string_constants.dart';
import '../../../../model/trip.dart';
import '../../../../model/user.dart';
import '../../../../util/ui_utils.dart';
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
  var isTripCompleted = false.obs;
  var isTripDeleted = false.obs;

  bool isUserHost() {
    return detailTrip.value.userIdHost == userData.value.uid;
  }

  bool isJoinedCurrentTrip() {
    return detailTrip.value.listIdMember?.contains(userData.value.uid) ?? false;
  }

  Future<void> getAllRouter() async {
    var routerSnapshot = db.collection("router").snapshots();
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
        isTripCompleted.value = trip.isComplete ?? false;

        if (detailTrip.value.listIdMember?.contains(userData.value.uid) ==
            true) {
          isWidgetJoinedVisible.value = true;
        } else {
          isWidgetJoinedVisible.value = false;
        }

        isTripDeleted.value = false;
        log("getTripDetail success: ${trip.toString()}");
      });
    } catch (e) {
      isTripDeleted.value = true;
      log("getTripDetail get user info fail: $e");
    }
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
      if (id == null) return;
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
          .then((value) => postFCM(text, "comment"))
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
                    postFCM("Số lượng member hiện tại:  ${listMember?.length}",
                        "join"),
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
      apiKey:
          "AAAAe0-zsYY:APA91bG9bdzbaJkWI6q22l1fJq1xNKiFNy1-VabYMH0hJ4Z48-IXrvMC10LNxop3mj_dhAUzcRiIuO8TpKeHCxXGcfI1DhBmhxWyotBic9Y9brDcQLncazDztqL3dVXj7i7tKBEPXrNL",
      enableLog: true,
      enableServerRespondLog: true,
    );
    try {
      var listFcmToken = <String>[];
      listFcmToken.add(userLeaderData.value.fcmToken ?? "");

      var title = "";
      if (type.contains("comment")) {
        title = "Có bình luận mới";
      } else {
        title = "Có người tham gia chuyến đi";
      }

      Map<String, dynamic> result =
          await flutterFCMWrapper.sendMessageByTokenID(
        userRegistrationTokens: listFcmToken,
        title: title,
        body: body,
        androidChannelID: DateTime.now().microsecondsSinceEpoch.toString(),
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      );
      Dog.e("FCM sendTopicMessage result ${result}");
    } catch (e) {
      Dog.e("FCM sendTopicMessage $e");
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
