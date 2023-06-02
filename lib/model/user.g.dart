// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      json['name'] as String,
      json['uid'] as String,
      json['email'] as String,
      json['avatar'] as String,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'name': instance.name,
      'uid': instance.uid,
      'email': instance.email,
      'avatar': instance.avatar,
    };
