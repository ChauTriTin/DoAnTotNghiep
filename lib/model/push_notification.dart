import 'package:appdiphuot/model/notification_data.dart';

class PushNotification {
  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;

  String? tripName;
  String? tripID;
  String? userName;
  String? userAvatar;
  String? notificationType;
  String? time;

  PushNotification(
      {this.title,
      this.body,
      this.dataTitle,
      this.dataBody,
      this.tripName,
      this.tripID,
      this.userName,
      this.userAvatar,
      this.notificationType,
      this.time});

  PushNotification.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    dataTitle = json['dataTitle'];
    dataBody = json['dataBody'];

    tripName = json['tripName'];
    tripID = json['tripID'];
    userName = json['userName'];
    userAvatar = json['userAvatar'];
    notificationType = json['notificationType'];
    time = json['time'];
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
    data['tripName'] = tripName;
    data['tripID'] = tripID;
    data['userName'] = userName;
    data['userAvatar'] = userAvatar;
    data['notificationType'] = notificationType;
    data['time'] = time;
    return data;
  }

  @override
  String toString() {
    return 'PushNotification{title: $title, body: $body, dataTitle: $dataTitle, dataBody: $dataBody, tripName: $tripName, tripID: $tripID, userName: $userName, userAvatar: $userAvatar, notificationType: $notificationType, time: $time}';
  }

  // static const String TYPE_MAP = "1";
  // static const String TYPE_MESSAGE = "2";
  // static const String TYPE_COMMENT = "3";
  // static const String TYPE_REMOVE = "4";
  // static const String TYPE_EXIT_ROUTER = "5";
  // static const String TYPE_JOIN_ROUTER = "6";
  // static const String TYPE_DELETE_ROUTER = "7";

  bool isTypeMap() {
    return notificationType == NotificationData.TYPE_MAP;
  }

  bool isTypeMessage() {
    return notificationType == NotificationData.TYPE_MESSAGE;
  }

  bool isTypeComment() {
    return notificationType == NotificationData.TYPE_COMMENT;
  }

  bool isTypeRemove() {
    return notificationType == NotificationData.TYPE_REMOVE;
  }

  bool isTypeExitRouter() {
    return notificationType == NotificationData.TYPE_EXIT_ROUTER;
  }

  bool isTypeJoinRouter() {
    return notificationType == NotificationData.TYPE_JOIN_ROUTER;
  }

  bool isRouterDeleted() {
    return notificationType == NotificationData.TYPE_DELETE_ROUTER;
  }

  bool isTypeRateTrip() {
    return notificationType == NotificationData.TYPE_RATE_TRIP;
  }
}
