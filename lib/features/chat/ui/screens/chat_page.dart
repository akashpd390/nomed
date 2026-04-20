import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomed/core/service_locator.dart';
import 'package:nomed/features/chat/bloc/chat_room_list_state.dart';
import 'package:nomed/features/chat/bloc/chat_room_membership_cubit.dart';
import 'package:nomed/features/chat/bloc/chat_rooms_list_bloc.dart';
import 'package:nomed/features/chat/bloc/message_bloc.dart';
import 'package:nomed/features/chat/domain/message_network.dart';
import 'package:nomed/features/chat/domain/message_socket.dart';
import 'package:nomed/features/chat/ui/screens/chat_messgae_page.dart';
import 'package:nomed/shared/network/room_network.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    context.read<ChatRoomsListBloc>().fetchChatRoomUserJoins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(title: Text("Chat"), centerTitle: true),

      body: BlocBuilder<ChatRoomsListBloc, ChatRoomListState>(
        builder: (context, state) {
          if (state is ChatRoomListErrorState) {
            return Center(child: Text(state.message));
          }
          if (state is ChatRoomListLoadedState) {
            final chatRooms = state.chatRooms.reversed.toList();
            return ListView.separated(
              itemCount: chatRooms.length,

              separatorBuilder: (_, _) => SizedBox(),
              itemBuilder: (_, index) {
                final item = chatRooms[index];

                return GestureDetector(
                  onTap: ()  {
                    /// roomid
                    ///
                    ///
                    ///
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: context
                                  .read<
                                    ChatRoomsListBloc
                                  >(), // 👈 pass existing
                            ),
                            BlocProvider(
                              create: (_) =>
                                  RoomMembershipCubit(getIt<RoomNetwork>()),
                            ),

                            BlocProvider(
                              create: (_) => MessageCubit(
                                getIt<MessageNetwork>(),
                                getIt<MessageSocket>(),
                              ),
                            ),
                          ],
                          child: ChatMessgaePage(item),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 20,
                    ),

                    margin: EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),

                    child: Row(
                      children: [
                        CircleAvatar(child: Icon(Icons.person)),
                        SizedBox(width: 20),
                        Text(item.roomName),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
