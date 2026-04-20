import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomed/features/home/bloc/room_details_state.dart';
import 'package:nomed/shared/network/room_network.dart';

class RoomDetailsCubit extends Cubit<RoomDetailsState> {
  final RoomNetwork api;

  RoomDetailsCubit(this.api) : super(RoomDetailsInitial());

  Future<void> fetchRoom(String roomId) async {
    emit(RoomDetailsLoading());
    try {
      final room = await api.fetchById(roomId);
      emit(RoomDetailsLoaded(room));
    } catch (e) {
      emit(RoomDetailsError(e.toString()));
    }
  }

  Future<void> joinRoom(String roomId) async {
    emit(RoomDetailsLoading());
    try {
      await api.joinRoom(roomId);
      emit(RoomJoinsState());
    } catch (e) {
      emit(RoomDetailsError(e.toString()));
    }
  }
}
