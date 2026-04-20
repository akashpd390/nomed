import 'package:nomed/features/home/model/room_model.dart';

sealed class RoomDetailsState {}

class RoomDetailsInitial extends RoomDetailsState {}

class RoomDetailsLoading extends RoomDetailsState {}

class RoomDetailsLoaded extends RoomDetailsState {
  final ChatRoom room;
  RoomDetailsLoaded(this.room);
}

class RoomJoinsState extends RoomDetailsState {}

class RoomDetailsError extends RoomDetailsState {
  final String message;
  RoomDetailsError(this.message);
}
