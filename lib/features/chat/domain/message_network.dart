import 'package:dio/dio.dart';
import 'package:nomed/features/chat/model/message_model.dart';

class MessageNetwork {
  final Dio dio;

  const MessageNetwork(this.dio);

  Future<MessageModel> sendMessage(String roomId, String content) async {
    final response = await dio.post(
      "/message",
      data: {"content": content, "roomId": roomId},
    );
    return MessageModel.fromJson(response.data["data"]);
  }

  Future<FetchMessageResponse> fethcMessage(
    String roomId, {
    int? limit,
    int? page,
  }) async {
    final resposne = await dio.get(
      "/message/$roomId",
      queryParameters: {
        if (page != null) "page": page,
        if (limit != null) "limit": limit,
      },
    );

    return FetchMessageResponse.fromJson(resposne.data);
  }
}

class FetchMessageResponse {
  final List<MessageModel> messages;
  final int limit;
  final int totalItems;
  final int totalPages;
  final int page;

  FetchMessageResponse({
    required this.messages,
    required this.limit,
    required this.totalItems,
    required this.totalPages,
    required this.page,
  });

  factory FetchMessageResponse.fromJson(Map<String, dynamic> json) {
    return FetchMessageResponse(
      messages: (json['messages'] as List)
          .map((e) => MessageModel.fromJson(e))
          .toList(),
      limit: json['limit'],
      totalItems: json['totalItems'],
      totalPages: json['totalPages'],
      page: json['page'],
    );
  }
}
