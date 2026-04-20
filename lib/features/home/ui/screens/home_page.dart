import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nomed/core/helper.dart';
import 'package:nomed/core/request_premmisiion_location.dart';
import 'package:nomed/core/service_locator.dart';
import 'package:nomed/features/auth/bloc/auth_cubit.dart';
import 'package:nomed/features/home/bloc/create_room_cubit.dart';
import 'package:nomed/features/home/bloc/room_cubit.dart';
import 'package:nomed/features/home/bloc/room_details_cubit.dart';
import 'package:nomed/features/home/bloc/room_state.dart';
import 'package:nomed/features/home/ui/screens/create_room_page.dart';
import 'package:nomed/shared/network/room_network.dart';
import 'package:nomed/features/home/ui/widgets/room_bottomsheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng? _initialPosition;
  GoogleMapController? _controller;
  LatLng? _mapCenter;
  Timer? _debounce;
  LatLng? _lastFetchedCenter;

  @override
  void initState() {
    super.initState();
    _getInitialLocation();
  }

  Future<void> _getInitialLocation() async {
    try {
      final position = await getCurrentLocation();
      final latlng = LatLng(position.latitude, position.longitude);
      setState(() {
        _initialPosition = latlng;
      });

      if (!mounted) return;
      context.read<RoomsCubit>().fetchNearbyRooms(
        lat: latlng.latitude,
        lng: latlng.longitude,
        radius: 1000, // meters
      );
    } catch (e) {
      // fallback to default location if error occurs
      setState(() {
        _initialPosition = const LatLng(37.7749, -122.4194); // SF
      });
      debugPrint('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initialPosition == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return BlocBuilder<RoomsCubit, RoomsState>(
      builder: (context, state) {
        final markers = <Marker>{};

        if (state is RoomsLoaded) {
          for (final room in state.rooms) {
            markers.add(
              Marker(
                markerId: MarkerId(room.id),
                position: LatLng(room.lat, room.lng),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure,
                ),
                infoWindow: InfoWindow(title: room.roomName),
                onTap: () => _showRoomDetails(context, room.id),
              ),
            );
          }
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Google Map'),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<AuthCubit>().logout();
                },
                icon: Icon(Icons.logout),
              ),
            ],
          ),
          body: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition!,
              zoom: 14,
            ),
            onCameraMove: (cameraPosition) {
              _mapCenter = cameraPosition.target;
            },

            onCameraIdle: () {
              if (_mapCenter == null) return;

              if (_lastFetchedCenter != null) {
                final distance = distanceBetween(
                  _mapCenter!,
                  _lastFetchedCenter!,
                );

                if (distance < 50) return; // meters
              }

              _lastFetchedCenter = _mapCenter;

              _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 400), () {
                context.read<RoomsCubit>().fetchNearbyRooms(
                  lat: _mapCenter!.latitude,
                  lng: _mapCenter!.longitude,
                  radius: 200000,
                );
              });
            },
            onMapCreated: (controller) => _controller = controller,
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () =>
                    EagerGestureRecognizer(), // <-- this makes map capture gestures inside PageView
              ),
            },
            markers: markers,

            zoomControlsEnabled: false, // show zoom buttons
            zoomGesturesEnabled: true, // must be true to zoom
            scrollGesturesEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              ///
              ///
              ///
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => CreateRoomCubit(getIt<RoomNetwork>()),
                    child: CreateRoomPage(),
                  ),
                ),
              );
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showRoomDetails(BuildContext context, String roomId) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,

      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      // ),
      builder: (_) {
        // return Container(height: 200);
        return BlocProvider(
          create: (_) =>
              RoomDetailsCubit(getIt<RoomNetwork>())..fetchRoom(roomId),

          child: RoomBottomsheet(roomId: roomId),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }
}
