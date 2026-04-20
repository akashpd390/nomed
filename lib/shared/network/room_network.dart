import 'package:dio/dio.dart';
import 'package:nomed/features/home/model/room_model.dart';

class RoomNetwork {
  final Dio dio;

  const RoomNetwork(this.dio);

  // create
  Future<ChatRoom> createRoom(
    String roomName,
    double lat,
    double lng, [
    String? description,
  ]) async {
    final response = await dio.post(
      "/room/create",
      data: {
        "roomName": roomName,
        "description": description,
        "location": {
          "type": "Point",
          "coordinates": [lng, lat],
        },
      },
    );

    return ChatRoom.fromJson(response.data["newRoom"]);
  }

  // join
  Future<void> joinRoom(String roomId) async {
    await dio.post("/room/join", data: {"roomId": roomId});

    return;
  }

  // fethc all
  Future<FetchAllRoomsResponse> fetchAllRooms(int page, int limit) async {
    final response = await dio.get(
      "/room",
      queryParameters: {"page": page, "limit": limit},
    );

    return FetchAllRoomsResponse.fromJson(response.data);
  }

  // fetch all users join

  Future<List<ChatRoom>> fethAllRoomUserJoins() async {
    final responnse = await dio.get("/room/joined");

    return (responnse.data as List)
        .map((element) => ChatRoom.fromJson(element))
        .toList();
  }

  // fetch nearby
  Future<List<ChatRoom>> fetchnearBy(
    double lat,
    double lng,
    double radius,
  ) async {
    final response = await dio.get(
      "/room/near?lat=$lat&lng=$lng&radius=$radius",
    );

    return (response.data as List).map((e) => ChatRoom.fromJson(e)).toList();
  }

  // fethc by id
  Future<ChatRoom> fetchById(String id) async {
    final response = await dio.get("/room/$id");
    return ChatRoom.fromJson(response.data);
  }


  Future<void> leaveRoom(String roomId)async{

    final response = await dio.delete("/room/$roomId/leave");
  }
}




class FetchAllRoomsResponse {
  final List<ChatRoom> rooms;
  final int page;
  final int limit;
  final int totalItem;
  final int totalPages;

  FetchAllRoomsResponse({
    required this.rooms,
    required this.page,
    required this.limit,
    required this.totalItem,
    required this.totalPages,
  });

  factory FetchAllRoomsResponse.fromJson(Map<String, dynamic> json) {
    return FetchAllRoomsResponse(
      rooms: (json["rooms"] as List).map((e) => ChatRoom.fromJson(e)).toList(),
      page: json["page"],
      limit: json["limit"],
      totalItem: json["totalItems"],
      totalPages: json["totalPages"],
    );
  }
}
