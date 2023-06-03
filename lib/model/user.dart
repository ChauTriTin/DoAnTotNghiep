import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class UserData {
  String name;
  String uid;
  String email;
  String avatar;


  UserData(this.name, this.uid, this.email, this.avatar);

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  @override
  String toString() {
    return 'UserData{name: $name, uid: $uid, email: $email, avatar: $avatar}';
  }
}