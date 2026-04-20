

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomed/shared/network/room_network.dart';

part 'chat_room_membership_state.dart';

class RoomMembershipCubit extends Cubit<RoomMembershipState> {
  final RoomNetwork api;

  RoomMembershipCubit(this.api) : super(RoomMembershipInitial());

  Future<void> leaveRoom(String roomId) async {
    emit(RoomMembershipLoading());

    try {
      await api.leaveRoom(roomId);

      emit(RoomMembershipLeft());
    } catch (e) {
      emit(RoomMembershipError(e.toString()));
    }
  }
}