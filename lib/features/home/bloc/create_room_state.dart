

import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateRoomState  {
  final String roomName;
  final String description;
  final LatLng? location;
  final bool isLoading;
  final String? error;
  final bool success;

  const CreateRoomState({
    this.roomName = '',
    this.description = '',
    this.location,
    this.isLoading = false,
    this.error,
    this.success = false,
  });

  CreateRoomState copyWith({
    String? roomName,
    String? description,
    LatLng? location,
    bool? isLoading,
    String? error,
    bool? success,
  }) {
    return CreateRoomState(
      roomName: roomName ?? this.roomName,
      description: description ?? this.description,
      location: location ?? this.location,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      success: success ?? false,
    );
  }

}