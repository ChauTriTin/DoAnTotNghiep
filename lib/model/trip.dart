import 'package:appdiphuot/model/place.dart';

import '../common/const/string_constants.dart';

class Trip {
  String? id;
  String? userIdHost;
  List<String>? listIdMember;
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
    return data;
  }
}
