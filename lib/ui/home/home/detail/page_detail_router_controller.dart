import 'dart:developer';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/db/firebase_helper.dart';
import 'package:appdiphuot/model/comment.dart';
import 'package:appdiphuot/util/log_dog_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../common/const/string_constants.dart';
import '../../../../model/trip.dart';
import '../../../../model/user.dart';
import '../../../user_singleton_controller.dart';

class DetailRouterController extends BaseController {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  var userLeaderData = UserData().obs;

  var userData = UserSingletonController.instance.userData;

  var detailTrip = Trip().obs;

  var commentData = <Comment>[].obs;

  var isWidgetJoinedVisible = true.obs;

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
    if (id == null) return;
    FirebaseHelper.collectionReferenceRouter
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        try {
          detailTrip.value =
              Trip.fromJson(documentSnapshot.data() as Map<String, dynamic>);

          if (detailTrip.value.listIdMember?.contains(userData.value.uid) ==
              true) {
            isWidgetJoinedVisible.value = true;
          } else {
            isWidgetJoinedVisible.value = false;
          }
        } catch (ex) {
          Dog.e("getDetailTrip: $ex");
        }
      }
    });
  }

  Future<void> getCommentRoute(String? id) async {
    try {
      if (id == null) return;
      var data = FirebaseHelper.collectionReferenceRouter.doc(id).snapshots();

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

      FirebaseHelper.collectionReferenceRouter
          .doc(id)
          .update({"comments": commentsData})
          .then((value) => Dog.d("addCommentRoute success"))
          .catchError((error) => Dog.e("addCommentRoute error: $error"));
    } catch (e) {
      log("addCommentRoute: $e");
    }
  }

  Future<void> joinedRouter(String? code) async {
    try {
      var id = userData.value.uid;
      Dog.e("joinedRouter id :$id");
      var listMember = detailTrip.value.listIdMember;
      if (detailTrip.value.id != code || code == null) {
        Dog.e("detailRoute error: wrong code");
      } else {
        if (listMember?.contains(id) == false || listMember != null) {
          listMember?.add(id!);
          FirebaseHelper.collectionReferenceRouter
              .doc(detailTrip.value.id)
              .update({"listIdMember": listMember})
              .then((value) => {
                    isWidgetJoinedVisible.value = true,
                    Dog.d("joinedRouter success")
                  })
              .catchError((error) => {Dog.e("joinedRouter error: $error")});
        }
      }
    } catch (e) {
      Dog.e("joinedRouter: $e");
    }
  }

  String getLeaderAvatar() {
    Dog.e("getLeaderAvatar: ${userLeaderData.value.avatar}");
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
}
