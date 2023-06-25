class PushNotification {
  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;

  PushNotification({this.title, this.body, this.dataTitle, this.dataBody});

  PushNotification.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    dataTitle = json['dataTitle'];
    dataBody = json['dataBody'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = body;
    data['dataTitle'] = dataTitle;
    data['dataBody'] = dataBody;
    return data;
  }
}
