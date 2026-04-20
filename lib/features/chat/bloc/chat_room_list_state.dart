import 'package:nomed/features/home/model/room_model.dart';

sealed class ChatRoomListState {}

class ChatRoomListInitilaState extends ChatRoomListState {}
class ChatRoomListLoadingState extends ChatRoomListState {}

class ChatRoomListLoadedState extends ChatRoomListState {
  final List<ChatRoom> chatRooms;

  ChatRoomListLoadedState({required this.chatRooms});
}

class ChatRoomListErrorState extends ChatRoomListState {
  final String message;

  ChatRoomListErrorState({required this.message});
}
