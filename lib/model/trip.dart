import 'package:appdiphuot/model/comment.dart';
import 'package:appdiphuot/model/place.dart';

import '../common/const/string_constants.dart';

class Trip {
  String? id;
  String? userIdHost;
  List<String>? listIdMember;

  @override
  String toString() {
    return 'Trip{id: $id, userIdHost: $userIdHost, listIdMember: $listIdMember, title: $title, des: $des, listImg: $listImg, placeStart: $placeStart, placeEnd: $placeEnd, listPlace: $listPlace, timeStart: $timeStart, timeEnd: $timeEnd, require: $require, isPublic: $isPublic, isComplete: $isComplete}';
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

  Trip({
    this.id,
    this.userIdHost,
    this.listIdMember,
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
  });

  String getFirstImageUrl() {
    return listImg?.firstOrNull ?? StringConstants.placeImgDefault;
  }

  Trip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userIdHost = json['userIdHost'];
    listIdMember = json['listIdMember'].cast<String>();
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

    timeStart = json['timeStart'];
    timeEnd = json['timeEnd'];
    require = json['require'];
    isPublic = json['isPublic'];
    isComplete = json['isComplete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userIdHost'] = userIdHost;
    data['listIdMember'] = listIdMember;
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
    return data;
  }
}
