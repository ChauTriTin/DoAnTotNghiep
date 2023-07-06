import 'package:appdiphuot/model/notification_data.dart';
import 'package:appdiphuot/model/trip.dart';
import 'package:appdiphuot/model/user.dart';

class PushNotification {
  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;
  Map<String, String>? data;

  // User data
  UserData? userData;
  Trip? tripDetail;

  PushNotification(
      {this.title, this.body, this.dataTitle, this.dataBody, this.data});

  PushNotification.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    dataTitle = json['dataTitle'];
    dataBody = json['dataBody'];
    if (json['data'] != null) {
      final Map<String, String> result = convertMap(json['data']);
      data ??= <String, String>{};
      data?.addAll(result);
    }
  }

  static Map<String, String> convertMap(Map<String, dynamic> originalMap) {
    return originalMap.map((key, value) => MapEntry(key, value.toString()));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = body;
    data['dataTitle'] = dataTitle;
    data['dataBody'] = dataBody;
    data['data'] = this.data;
    return data;
  }

  NotificationData? getNotificationData() {
    if (data == null) return null;
    return NotificationData.fromJson(data!);
  }

  @override
  String toString() {
    return 'PushNotification{title: $title, body: $body, dataTitle: $dataTitle, dataBody: $dataBody, data: $data}';
  }
}
