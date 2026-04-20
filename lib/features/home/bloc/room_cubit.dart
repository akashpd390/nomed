import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomed/features/home/bloc/room_state.dart';
import 'package:nomed/shared/network/room_network.dart';

class RoomsCubit extends Cubit<RoomsState> {
  final RoomNetwork api;
  RoomsCubit(this.api) : super(RoomsInitial());

  /// fetch all rooms
  Future<void> fetchAllRooms(int page, int limit) async {
    emit(RoomsLoading());
    try {
      final response = await api.fetchAllRooms(page, limit);
      emit(RoomsLoaded(response.rooms));
    } catch (e) {
      emit(RoomsError(e.toString()));
    }
  }

  /// fetch nearby rooms
  Future<void> fetchNearbyRooms({
    required double lat,
    required double lng,
    required double radius,
  }) async {
    emit(RoomsLoading());
    try {
      final response = await api.fetchnearBy(lat, lng, radius);

      emit(RoomsLoaded(response));
    } catch (e) {
      emit(RoomsError(e.toString()));
    }
  }

  /// fetch one room by id
  // Future<void> fetchRoomById(String roomId) async {
  //   try {
  //     emit(RoomsLoading());
  //     final response = await api.fetchById(roomId);
  //     RoomByIdLoaded(response);
  //   } catch (e) {
  //     emit(RoomsError(e.toString()));
     
  //   }
  // }

    

}
