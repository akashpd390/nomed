import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomed/features/chat/bloc/chat_room_list_state.dart';
import 'package:nomed/shared/network/room_network.dart';

class ChatRoomsListBloc extends Cubit<ChatRoomListState> {
  final RoomNetwork api;

  ChatRoomsListBloc(this.api) : super(ChatRoomListInitilaState());

  Future<void> fetchChatRoomUserJoins() async {
    try {
      emit(ChatRoomListLoadingState());
      final result = await api.fethAllRoomUserJoins();
      emit(ChatRoomListLoadedState(chatRooms: result));
    } catch (e) {
      emit(ChatRoomListErrorState(message: e.toString()));
    }
  }

  void removeRoom(String roomId) {
    if (state is ChatRoomListLoadedState) {
      final current = (state as ChatRoomListLoadedState).chatRooms;

      final updated = current.where((r) => r.id != roomId).toList();

      emit(ChatRoomListLoadedState(chatRooms: updated));
    }
  }
}
