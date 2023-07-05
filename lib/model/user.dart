import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/model/user_rate.dart';
import 'package:get/get.dart';

class UserData {
  String? name;
  String? uid;
  String? email;
  String? phone;
  String? bsx;
  String? address;
  String? birthday;
  int? gender; // 1: Male, 2: female, 3: other

  String? avatar;
  String? fcmToken;
  double? lat;
  double? long;

  List<UserRate>? rates;

  UserData({
    this.name,
    this.uid,
    this.email,
    this.phone,
    this.bsx,
    this.address,
    this.birthday,
    this.gender,
    this.avatar,
    this.fcmToken,
    this.lat,
    this.long,
    this.rates,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uid = json['uid'];
    email = json['email'];
    phone = json['phone'];
    bsx = json['bsx'];
    address = json['address'];
    birthday = json['birthday'];
    gender = json['gender'];
    avatar = json['avatar'];
    fcmToken = json['fcmToken'];
    lat = json['lat'];
    long = json['long'];

    if (json['rates'] != null) {
      rates = <UserRate>[];
      json['rates'].forEach((v) {
        rates!.add(UserRate.fromJson(v));
      });
    }
  }


  @override
  String toString() {
    return 'UserData{name: $name, uid: $uid, email: $email, phone: $phone, bsx: $bsx, address: $address, birthday: $birthday, gender: $gender, avatar: $avatar, fcmToken: $fcmToken, lat: $lat, long: $long, rates: $rates}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['uid'] = uid;
    data['email'] = email;
    data['phone'] = phone;
    data['bsx'] = bsx;
    data['address'] = address;
    data['birthday'] = birthday;
    data['gender'] = gender;
    data['avatar'] = avatar;
    data['fcmToken'] = fcmToken;
    data['long'] = long;
    if (rates != null) {
      data['rates'] = rates!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String getAvatar() {
    if (avatar == null || avatar?.isEmpty == true) {
      return StringConstants.avatarImgDefault;
    }
    return avatar!;
  }

  double getRate() {
    double rate = 5;
    if (rates != null && rates?.isNotEmpty == true) {
      double totalRate = 0;
      rates?.forEach((element) {
        totalRate = totalRate + (element.rate ?? 5);
      });
      rate = totalRate / (rates!.length);
    }
    return rate;
  }
}
