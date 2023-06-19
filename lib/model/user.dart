import 'package:appdiphuot/common/const/string_constants.dart';

class UserData {
  String? name;
  String? uid;
  String? email;
  String? phone;
  String? address;
  String? birthday;
  String? gender;

  String? avatar;
  String? fcmToken;
  double? lat;
  double? long;

  UserData({
    this.name,
    this.uid,
    this.email,
    this.phone,
    this.address,
    this.birthday,
    this.gender,
    this.avatar,
    this.fcmToken,
    this.lat,
    this.long,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uid = json['uid'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    birthday = json['birthday'];
    gender = json['gender'];
    avatar = json['avatar'];
    fcmToken = json['fcmToken'];
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['uid'] = uid;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['birthday'] = birthday;
    data['gender'] = gender;
    data['avatar'] = avatar;
    data['fcmToken'] = fcmToken;
    data['long'] = long;
    return data;
  }

  String getAvatar() {
    if (avatar == null || avatar?.isEmpty == true) {
      return StringConstants.avatarImgDefault;
    }
    return avatar!;
  }
}
