import 'package:flutter_chat_types/flutter_chat_types.dart';

class Chat {
  List<Message> messages = [];

  Chat(this.messages);

  Chat.fromJson(Map<String, dynamic> json) {
    if (json['messages'] != null) {
      json['messages'].forEach((v) {
        messages.add(Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['messages'] = messages.map((message) => message.toJson()).toList();
    return data;
  }
}