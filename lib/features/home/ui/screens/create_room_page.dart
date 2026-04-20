import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nomed/components/custom_text_field.dart';
import 'package:nomed/core/request_premmisiion_location.dart';
import 'package:nomed/features/home/bloc/create_room_cubit.dart';
import 'package:nomed/features/home/bloc/create_room_state.dart';

class CreateRoomPage extends StatefulWidget {
  final LatLng? initialLocation;

  const CreateRoomPage({super.key, this.initialLocation});

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final _formKey = GlobalKey<FormState>();

  final _roomNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  LatLng? _initialPosition;
  GoogleMapController? _controller;
  LatLng? _mapCenter;

  @override
  void initState() {
    super.initState();
    _getInitialLocation();
  }

  Future<void> _getInitialLocation() async {
    try {
      final position = await getCurrentLocation();
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      setState(() {
        _initialPosition = const LatLng(37.7749, -122.4194);
      });
      debugPrint('Error getting location: $e');
    }
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<CreateRoomCubit>();

    await cubit.createRoom();

    final state = cubit.state;

    if (state.success) {
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initialPosition == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Create Room")),
    
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      /// ROOM NAME
                      CustomTextField(
                        textEditingController: _roomNameController,
                        title: "Room Name",
                        hintText: "Enter room name",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Room name is required";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          context.read<CreateRoomCubit>().setRoomName(value);
                        },
                      ),
    
                      const SizedBox(height: 16),
    
                      /// DESCRIPTION
                      CustomTextField(
                        textEditingController: _descriptionController,
                        maxLines: 4,
                        title: "Description (optional)",
                        hintText: "What is this room about?",
                        onChanged: (value) {
                          context.read<CreateRoomCubit>().setDescription(
                            value,
                          );
                        },
                      ),
    
                      const SizedBox(height: 24),
    
                      /// LOCATION TEXT
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _mapCenter != null
                                    ? "Lat: ${_mapCenter!.latitude.toStringAsFixed(4)}, "
                                          "Lng: ${_mapCenter!.longitude.toStringAsFixed(4)}"
                                    : "Move map to select location",
                                style: TextStyle(
                                  color: _mapCenter != null
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
    
                      const SizedBox(height: 12),
    
                      /// MAP
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: _initialPosition!,
                                zoom: 14,
                              ),
    
                              onCameraMove: (position) {
                                _mapCenter = position.target;
                              },
    
                              onCameraIdle: () {
                                if (_mapCenter == null) return;
    
                                setState(() {});
    
                                context.read<CreateRoomCubit>().setLocation(
                                  _mapCenter!,
                                );
                              },
    
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
    
                              onMapCreated: (controller) =>
                                  _controller = controller,
    
                              gestureRecognizers:
                                  <Factory<OneSequenceGestureRecognizer>>{
                                    Factory<OneSequenceGestureRecognizer>(
                                      () => EagerGestureRecognizer(),
                                    ),
                                  },
                            ),
    
                            const Icon(
                              Icons.location_pin,
                              size: 40,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    
                /// CREATE BUTTON
                SizedBox(
                  width: double.infinity,
                  child: BlocBuilder<CreateRoomCubit, CreateRoomState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state.isLoading ? null : _submit,
                        child: state.isLoading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text("Create"),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
