class UserSummary {
  final String id;
  final String? username;
  final String? email;

  UserSummary({required this.id, this.username, this.email});

  factory UserSummary.fromJson(dynamic json) {
    if (json is String) {
      // backend sent only ID
      return UserSummary(id: json);
    } else if (json is Map<String, dynamic>) {
      // backend sent full user object
      return UserSummary(
        id: json['_id'] ?? '',
        username: json['username'],
        email: json['email'],
      );
    } else {
      throw Exception('Invalid user data');
    }
  }
}

class ChatRoom {
  final String id;
  final String roomName;
  final String? description;
  final double lat;
  final double lng;
  final UserSummary createdBy;
  final List<UserSummary> members;

  ChatRoom({
    required this.id,
    required this.roomName,
    this.description,
    required this.lat,
    required this.lng,
    required this.createdBy,
    required this.members,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    final coords = json['location']['coordinates'] as List<dynamic>;
    return ChatRoom(
      id: json['_id'] ?? '', // MongoDB _id
      roomName: json['roomName'] ?? '',
      description: json['description'],
      lng: (coords[0] as num).toDouble(),
      lat: (coords[1] as num).toDouble(),
      createdBy: UserSummary.fromJson(json['createdBy']),
      members: (json['members'] as List<dynamic>)
          .map((e) => UserSummary.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomName': roomName,
      'description': description,
      'location': {
        'type': 'Point',
        'coordinates': [lng, lat],
      },
      'createdBy': createdBy,
      'members': members,
    };
  }
}
