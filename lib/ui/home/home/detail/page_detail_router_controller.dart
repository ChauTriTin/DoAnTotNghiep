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

class DetailRouterController extends BaseController {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  var userData = UserData().obs;

  var detailRoute = Trip().obs;

  var commentData = <Comment>[].obs;

  var isWidgetJoinVisible = true.obs;

  Future<void> getUserInfo(String uid) async {
    try {
      log("getUserInfo uid: $uid");
      if (uid == "") return;
      _users.doc(uid).snapshots().listen((value) {
        DocumentSnapshot<Map<String, dynamic>>? userMap =
            value as DocumentSnapshot<Map<String, dynamic>>?;
        if (userMap == null || userMap.data() == null) return;

        var user = UserData.fromJson((userMap).data()!);
        userData.value = user;
        if (detailRoute.value.listIdMember?.contains(user.uid) == true) {
          isWidgetJoinVisible.value = true;
        } else {
          isWidgetJoinVisible.value = false;
        }
        log("getUserInfo success: ${user.toString()}");
      });
    } catch (e) {
      log("getUserInfo get user info fail: $e");
    }
  }

  Future<void> getCommentRoute(String? id) async {
    try {
      if (id == null) return;
      var data = FirebaseHelper.collectionReferenceRouter
          .doc(id)
          .collection("comments")
          .snapshots();

      data.listen((snapshot) {
        List<Comment> convertedList =
            snapshot.docs.map((doc) => Comment.fromJson(doc.data())).toList();
        Dog.d("getCommentRoute listen: ${convertedList.length}");
        commentData.value = convertedList;
      });
    } catch (e) {
      Dog.e("getCommentRoute: $e");
    }
  }

  Future<void> addCommentRoute(String? id, String text) async {
    try {
      Dog.d("addCommentRoute id: $id");
      if (id == null) return;
      var listComment = commentData.value;
      listComment.add(Comment(DateTime.now().millisecondsSinceEpoch.toString(),
          getAvatar(), userData.value.name ?? "", text, <Comment>[]));

      List<Map<String, dynamic>> commentsData =
          listComment.map((comment) => comment.toJson()).toList();

      Map<String, dynamic> data = {
        'comments': commentsData,
      };

      FirebaseHelper.collectionReferenceRouter
          .doc(id)
          .set(data, SetOptions(merge: true))
          .then((value) => Dog.d("addCommentRoute success"))
          .catchError((error) => Dog.e("addCommentRoute error: $error"));
    } catch (e) {
      log("addCommentRoute: $e");
    }
  }

  String getAvatar() {
    String avatarUrl = userData.value.avatar ?? "";
    if (avatarUrl.isEmpty) {
      return StringConstants.avatarImgDefault;
    } else {
      return avatarUrl;
    }
  }

  String getNameLeader() {
    String name = userData.value.name ?? "";
    if (name.isEmpty) {
      return "";
    } else {
      return name;
    }
  }
}
