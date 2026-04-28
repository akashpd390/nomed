import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nomed/components/custom_text_field.dart';
import 'package:nomed/features/auth/bloc/auth_cubit.dart';
import 'package:nomed/features/chat/bloc/chat_room_membership_cubit.dart';
import 'package:nomed/features/chat/bloc/chat_rooms_list_bloc.dart';
import 'package:nomed/features/chat/bloc/message_bloc.dart';
import 'package:nomed/features/chat/bloc/message_state.dart';
import 'package:nomed/features/chat/model/message_model.dart';
import 'package:nomed/features/home/model/room_model.dart';

class ChatMessgaePage extends StatefulWidget {
  final ChatRoom room;

  const ChatMessgaePage(this.room, {super.key});

  @override
  State<ChatMessgaePage> createState() => _ChatMessgaePageState();
}

class _ChatMessgaePageState extends State<ChatMessgaePage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final int limit = 50;

  @override
  void initState() {
    super.initState();
    context.read<MessageCubit>().fetchInitialMessages(widget.room.id, limit);
    // context.read<MessageCubit>().startListening();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    // reverse: true → TOP = maxScrollExtent
    if (position.pixels >= position.maxScrollExtent - 50) {
      context.read<MessageCubit>().fetchMore(widget.room.id, limit);
    }
  }

  @override
  Widget build(BuildContext context) {
    final myUserId = context.read<AuthCubit>().userId;

    return MultiBlocListener(
      listeners: [
        BlocListener<RoomMembershipCubit, RoomMembershipState>(
          listener: (context, state) {
            if (state is RoomMembershipLeft) {
              context.read<ChatRoomsListBloc>().removeRoom(widget.room.id);
              Navigator.pop(context, true);
            }
          },
        ),
        BlocListener<MessageCubit, MessageState>(
          listener: (context, state) {
            if (state.joinedUser != null) {
              Fluttertoast.showToast(
                msg: "${state.joinedUser?.username} Joins",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios),
              ),

              SizedBox(width: 10),
              CircleAvatar(child: Icon(Icons.person)),
              SizedBox(width: MediaQuery.of(context).size.width * 0.2),
              Text(widget.room.roomName, textAlign: TextAlign.center),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.read<RoomMembershipCubit>().leaveRoom(widget.room.id);
              },
              icon: Icon(Icons.logout),
            ),
          ],
          // centerTitle: true,
          // title: Text(room.roomName),
        ),
        body: BlocBuilder<MessageCubit, MessageState>(
          builder: (context, state) {
            if (state.isLoading && state.messages.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error != null && state.messages.isEmpty) {
              return Center(child: Text(state.error!));
            }
            final messages = state.messages.reversed.toList();
            debugPrint(messages.last.content);
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    controller: _scrollController,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final item = messages[index];
                      return _buildMessages(
                        context,
                        item,
                        myUserId == item.createdBy.id,
                      );
                    },
                  ),
                ),
                CustomTextField(
                  margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).viewInsets.bottom + 12,
                    horizontal: 12,
                  ),
                  hintText: "Enter your message",
                  textEditingController: _controller,

                  suffixIcon: InkWell(
                    onTap: () {
                      // sned message
                      if (_controller.text.isNotEmpty) {
                        context.read<MessageCubit>().sendMessage(
                          widget.room.id,
                          _controller.text,
                        );
                      }
                      _controller.text = "";
                    },

                    child: Icon(Icons.send_sharp),
                  ),
                ),
              ],
            );
          },
        ),

        bottomNavigationBar: SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: []),
        ),
      ),
    );
  }

  Widget _buildMessages(BuildContext context, MessageModel message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isMe
                    ? Theme.of(context).scaffoldBackgroundColor
                    : Theme.of(context).primaryColor,
              ),
              child: Text(
                message.content.trim(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 18,
                  color: isMe
                      ? Colors.black
                      : Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
            Text(message.createdBy.username),
          ],
        ),
      ),
    );
  }
}
