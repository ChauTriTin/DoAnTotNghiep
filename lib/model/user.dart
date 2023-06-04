import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

import '../common/const/string_constants.dart';

part 'user.g.dart';

@JsonSerializable()
class UserData {
  var name = "";
  var uid = "";
  var email = "";
  var avatar = "";

  String getAvatar() {
    if (avatar == null || avatar?.isEmpty == true) {
      return avatar!;
    }
    else {
      return StringConstants.avatarImgDefault;
    }
  }

  UserData(this.name, this.uid, this.email, this.avatar);

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  @override
  String toString() {
    return 'UserData{name: $name, uid: $uid, email: $email, avatar: $avatar}';
  }
}
