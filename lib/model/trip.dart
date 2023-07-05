import 'dart:convert';

import 'package:appdiphuot/model/comment.dart';
import 'package:appdiphuot/model/place.dart';
import 'package:appdiphuot/model/rate.dart';
import 'package:flutter/material.dart';

import '../common/const/string_constants.dart';
import '../util/log_dog_utils.dart';

class Trip {
  String? id;
  String? userIdHost;
  String? userHostName;
  List<String>? listIdMember;
  List<String>? listIdMemberBlocked;

  @override
  String toString() {
    return 'Trip{id: $id, userIdHost: $userIdHost, userHostName: $userHostName, listIdMember: $listIdMember, listIdMemberBlocked: $listIdMemberBlocked, title: $title, des: $des, listImg: $listImg, placeStart: $placeStart, placeEnd: $placeEnd, listPlace: $listPlace, timeStart: $timeStart, timeEnd: $timeEnd, require: $require, isPublic: $isPublic, isComplete: $isComplete, comments: $comments, rates: $rates}';
  }

  String? title;
  String? des;
  List<String>? listImg;
  Place? placeStart;
  Place? placeEnd;
  List<Place>? listPlace;
  String? timeStart;
  String? timeEnd;
  String? require;
  bool? isPublic;
  bool? isComplete;
  List<Comment>? comments;
  String? createdAt;

  // List<Rate>? rates;
  Map<String, dynamic>? rates;

  Trip({
    this.id,
    this.userIdHost,
    this.userHostName,
    this.listIdMember,
    this.listIdMemberBlocked,
    this.title,
    this.des,
    this.listImg,
    this.placeStart,
    this.placeEnd,
    this.listPlace,
    this.timeStart,
    this.timeEnd,
    this.require,
    this.isPublic,
    this.isComplete,
    this.comments,
    this.rates,
  });

  String getFirstImageUrl() {
    return listImg?.firstOrNull ?? StringConstants.placeImgDefault;
  }

  Trip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userIdHost = json['userIdHost'];
    userHostName = json['userHostName'];
    listIdMember = json['listIdMember'].cast<String>();
    listIdMemberBlocked = json['listIdMemberBlocked'] != null
        ? List<String>.from(json['listIdMemberBlocked'])
        : null;
    title = json['title'];
    des = json['des'];
    listImg = json['listImg'].cast<String>();
    placeStart =
        json['placeStart'] != null ? Place.fromJson(json['placeStart']) : null;

    placeEnd =
        json['placeEnd'] != null ? Place.fromJson(json['placeEnd']) : null;
    if (json['listPlace'] != null) {
      listPlace = <Place>[];
      json['listPlace'].forEach((v) {
        listPlace!.add(Place.fromJson(v));
      });
    }

    if (json['comments'] != null) {
      comments = <Comment>[];
      json['comments'].forEach((v) {
        comments!.add(Comment.fromJson(v));
      });
    }

    try {
      if (json['rates'] != null) {
        // rates = <Rate>[];
        // json['rates'].forEach((v) {
        //   rates!.add(Rate.fromJson(v));
        // });

        // debugPrint(">>>rate json['rates'] ${json['rates']}");
        // rates = <String, Rate>{};
        // json['rates'].forEach((v) {
        //   debugPrint(">>>rate v $v");
        // var r = Rate.fromJson(v);
        // debugPrint(">>>trip r ${r.toJson()}");
        // rates?.addEntries({"${r.idUser}": r}.entries);
        // });

        // var map = jsonDecode(json['rates']);
        // debugPrint(">>>rate map ${jsonEncode(map)}");

        // var j = json['rates'];
        // debugPrint(">>>rate ~ j: $j");

        // var j2 = jsonEncode(j);
        // debugPrint(">>>rate ~ j2: $j2");

        // String jsonString = _convertToJsonStringQuotes(raw: json['rates']);
        // debugPrint(">>>rate Test 1: $jsonString");

        final Map<String, dynamic> result = json['rates'];
        // final Map<String, dynamic> result = jsonDecode(j2);
        // debugPrint('>>>rate ~ Test 2: $result');

        rates ??= <String, dynamic>{};
        rates?.addAll(result);
        // debugPrint('>>>rate ~ rates: $rates');
      }
    } catch (e) {
      debugPrint(">>>rate e $e");
    }

    timeStart = json['timeStart'];
    timeEnd = json['timeEnd'];
    require = json['require'];
    isPublic = json['isPublic'];
    isComplete = json['isComplete'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userIdHost'] = userIdHost;
    data['userHostName'] = userHostName;
    data['listIdMember'] = listIdMember;
    data['listIdMemberBlocked'] = listIdMemberBlocked;
    data['title'] = title;
    data['des'] = des;
    data['listImg'] = listImg;
    if (placeStart != null) {
      data['placeStart'] = placeStart!.toJson();
    }
    if (placeEnd != null) {
      data['placeEnd'] = placeEnd!.toJson();
    }
    if (listPlace != null) {
      data['listPlace'] = listPlace!.map((v) => v.toJson()).toList();
    }
    data['timeStart'] = timeStart;
    data['timeEnd'] = timeEnd;
    data['require'] = require;
    data['isPublic'] = isPublic;
    data['isComplete'] = isComplete;
    data['comments'] = comments;
    data['rates'] = rates;
    data['createdAt'] = createdAt;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Trip &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userIdHost == other.userIdHost &&
          userHostName == other.userHostName &&
          listIdMember == other.listIdMember &&
          listIdMemberBlocked == other.listIdMemberBlocked &&
          title == other.title &&
          des == other.des &&
          listImg == other.listImg &&
          placeStart == other.placeStart &&
          placeEnd == other.placeEnd &&
          listPlace == other.listPlace &&
          timeStart == other.timeStart &&
          timeEnd == other.timeEnd &&
          require == other.require &&
          isPublic == other.isPublic &&
          isComplete == other.isComplete &&
          comments == other.comments &&
          rates == other.rates &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      userIdHost.hashCode ^
      userHostName.hashCode ^
      listIdMember.hashCode ^
      listIdMemberBlocked.hashCode ^
      title.hashCode ^
      des.hashCode ^
      listImg.hashCode ^
      placeStart.hashCode ^
      placeEnd.hashCode ^
      listPlace.hashCode ^
      timeStart.hashCode ^
      timeEnd.hashCode ^
      require.hashCode ^
      isPublic.hashCode ^
      isComplete.hashCode ^
      comments.hashCode ^
      createdAt.hashCode ^
      rates.hashCode;

// String _convertToJsonStringQuotes({required String raw}) {
//   /// remove space
//   String jsonString = raw.replaceAll(" ", "");
//
//   /// add quotes to json string
//   jsonString = jsonString.replaceAll('{', '{"');
//   jsonString = jsonString.replaceAll(':', '": "');
//   jsonString = jsonString.replaceAll(',', '", "');
//   jsonString = jsonString.replaceAll('}', '"}');
//
//   /// remove quotes on object json string
//   jsonString = jsonString.replaceAll('"{"', '{"');
//   jsonString = jsonString.replaceAll('"}"', '"}');
//
//   /// remove quotes on array json string
//   jsonString = jsonString.replaceAll('"[{', '[{');
//   jsonString = jsonString.replaceAll('}]"', '}]');
//
//   return jsonString;
// }
}
