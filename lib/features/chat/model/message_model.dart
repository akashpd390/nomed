class MessageModel {
  final String? id;
  final String content;
  final UserMessageModel createdBy;
  final String roomId;
  final DateTime? createdAt;

  MessageModel({
    this.id,
    required this.content,
    required this.createdBy,
    required this.roomId,
    this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
      content: json['content'],
      createdBy: UserMessageModel.toJson(json['createdBy']),
      roomId: json['roomId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'content': content, 'createdBy': createdBy, 'roomId': roomId};
  }
}

class UserMessageModel {
  final String? id;

  final String username;
  final String email;

  UserMessageModel({this.id, required this.username, required this.email});

  factory UserMessageModel.toJson(Map<String, dynamic> json) {
    return UserMessageModel(id: json['_id'], username: json['username'], email: json['email']);
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'email': email};
  }
}
