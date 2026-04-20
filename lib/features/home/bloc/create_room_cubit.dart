import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nomed/shared/network/room_network.dart';
import 'create_room_state.dart';

class CreateRoomCubit extends Cubit<CreateRoomState> {
  final RoomNetwork repository; // your API layer

  CreateRoomCubit(this.repository) : super(const CreateRoomState());

  void setRoomName(String value) {
    emit(state.copyWith(roomName: value));
  }

  void setDescription(String value) {
    emit(state.copyWith(description: value));
  }

  void setLocation(LatLng location) {
    emit(state.copyWith(location: location));
  }

  Future<void> createRoom() async {
    if (state.roomName.trim().isEmpty) {
      emit(state.copyWith(error: "Room name required"));
      return;
    }

    if (state.location == null) {
      emit(state.copyWith(error: "Location required"));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    try {
      await repository.createRoom(
        state.roomName,
        state.location!.latitude,
        state.location!.longitude,
        state.description,
      );

      emit(state.copyWith(isLoading: false, success: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void reset() {
    emit(const CreateRoomState());
  }
}
