class UserData {
  String? name;
  String? uid;
  String? email;
  String? avatar;
  String? fcmToken;
  double? lat;
  double? long;

  UserData({
    this.name,
    this.uid,
    this.email,
    this.avatar,
    this.fcmToken,
    this.lat,
    this.long,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uid = json['uid'];
    email = json['email'];
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
    data['avatar'] = avatar;
    data['fcmToken'] = fcmToken;
    data['long'] = long;
    return data;
  }
}
