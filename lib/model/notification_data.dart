class NotificationData {
  String? tripID;
  String? userID;
  String?
      notificationType; // 1: thoong bao trong map (hư xe, sos...), 2: tin nhan, 3: remove, 4: OUT NHÓM
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
}
