import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nomed/features/auth/bloc/auth_cubit.dart';
import 'package:nomed/features/home/bloc/room_details_cubit.dart';
import 'package:nomed/features/home/bloc/room_details_state.dart';

class RoomBottomsheet extends StatefulWidget {
  final String roomId;
  const RoomBottomsheet({super.key, required this.roomId});

  @override
  State<RoomBottomsheet> createState() => _RoomBottomsheetState();
}

class _RoomBottomsheetState extends State<RoomBottomsheet> {
  @override
  void initState() {
    super.initState();

    // Future.microtask(() {
    //   if (!mounted) return;
    //   context.read<RoomsCubit>().fetchRoomById(widget.roomId);
    // });
  }

  @override
  Widget build(BuildContext context) {
    final meId = context.read<AuthCubit>().userId;

    return SafeArea(
      child: BlocConsumer<RoomDetailsCubit, RoomDetailsState>(
        listener: (context, state) {
          if (state is RoomJoinsState) {
            Navigator.pop(context);
            Fluttertoast.showToast(
              msg: "User joins this room",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
            // ScaffoldMessenger.of(
            //   context,
            // ).showSnackBar(SnackBar(content: Text("User joins this room")));
          }
        },
        builder: (context, state) {
          // if (state is )

          if (state is RoomDetailsLoading) {
            return Container(
              padding: EdgeInsets.all(24),
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is RoomDetailsLoaded) {
            final room = state.room;

            // print("is this room ${room.id}");
            final isMember = room.members.any((u) => u.id == meId);

            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(radius: 20, child: Icon(Icons.person)),
                    const SizedBox(height: 20),
                    Text(
                      room.roomName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (room.description != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(room.description!),
                      ),
                    const SizedBox(height: 16),
                    Text("Members: ${room.members.length}"),
                    const SizedBox(height: 16),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: ListView.builder(
                        itemCount: room.members.length,
                        itemBuilder: (_, index) {
                          final item = room.members[index];

                          return Row(
                            children: [
                              Icon(Icons.person),
                              SizedBox(width: 20),
                              Text(
                                item.username ?? "",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontWeight: item.id == meId
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: item.id == meId
                                          ? Theme.of(context).primaryColor
                                          : Colors.black,
                                    ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel"),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: isMember
                              ? null
                              : () {
                                  context.read<RoomDetailsCubit>().joinRoom(
                                    widget.roomId,
                                  );
                                },
                          child: Text(!isMember ? "Join" : "Already Memeber"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is RoomDetailsError) {
            return Container(
              height: 200,
              padding: const EdgeInsets.all(24),
              child: Text(state.message),
            );
          }

          return Container(height: 200);
        },
      ),
    );
  }
}
