class Comment {
  String? id;
  String? avatarUrl;
  String? name;
  String? content;
  List<Comment>? replyComment;

  Comment(this.id, this.avatarUrl, this.name, this.content, this.replyComment);

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatarUrl = json['avatarUrl'];
    name = json['name'];
    content = json['content'];
    if (json['replyComment'] == null) {
      replyComment = null;
    } else {
      replyComment = (json['replyComment'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatarUrl': avatarUrl,
      'name': name,
      'content': content,
      'replyComment': replyComment?.map((comment) => comment.toJson()).toList(),
    };
  }
}
