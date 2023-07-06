class NotificationData {
  String? tripID;
  String? userID;
  String?
      notificationType; //1: thông báo trong map (hư xe, sos...), 2: tin nhan, 3: "bình luận", 4: remove, 5: OUT NHÓM, 6: Tham gia
  String? time;

  NotificationData(this.tripID, this.userID, this.notificationType, this.time);

  NotificationData.fromJson(Map<String, dynamic> json) {
    tripID = json['tripID'];
    userID = json['userID'];
    notificationType = json['notificationType'];
    time = json['time'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['tripID'] = tripID ?? "";
    data['userID'] = userID ?? "";
    data['notificationType'] = notificationType ?? "";
    data['time'] = time ?? "";
    return data;
  }

  static const String TYPE_MAP = "1";
  static const String TYPE_MESSAGE = "2";
  static const String TYPE_COMMENT = "3";
  static const String TYPE_REMOVE = "4";
  static const String TYPE_EXIT_ROUTER = "5";
  static const String TYPE_JOIN_ROUTER = "6";
  static const String TYPE_DELETE_ROUTER = "7";

  bool isTypeMap() {
    return notificationType == TYPE_MAP;
  }

  bool isTypeMessage() {
    return notificationType == TYPE_MESSAGE;
  }

  bool isTypeComment() {
    return notificationType == TYPE_COMMENT;
  }

  bool isTypeRemove() {
    return notificationType == TYPE_REMOVE;
  }

  bool isTypeExitRouter() {
    return notificationType == TYPE_EXIT_ROUTER;
  }

  bool isTypeJoinRouter() {
    return notificationType == TYPE_JOIN_ROUTER;
  }
}
