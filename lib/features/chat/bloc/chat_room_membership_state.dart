part of 'chat_room_membership_cubit.dart';

sealed class RoomMembershipState {}

class RoomMembershipInitial extends RoomMembershipState {}

class RoomMembershipLoading extends RoomMembershipState {}

class RoomMembershipLeft extends RoomMembershipState {}

class RoomMembershipError extends RoomMembershipState {
  final String error;

  RoomMembershipError(this.error);
}
