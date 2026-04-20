import 'package:nomed/features/home/model/room_model.dart';

sealed class RoomsState {
  const RoomsState();
}

class RoomsInitial extends RoomsState {}

class RoomsLoading extends RoomsState {}

class RoomsLoaded extends RoomsState {
  final List<ChatRoom> rooms;
  const RoomsLoaded(this.rooms);
}

class RoomByIdLoaded extends RoomsState {
  final ChatRoom room;
  const RoomByIdLoaded(this.room);
}

class RoomsError extends RoomsState {
  final String message;
  const RoomsError(this.message);
}
