import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:nomed/features/auth/domain/auth_socket.dart';
import 'package:nomed/features/auth/model/user_model.dart';
import 'package:nomed/features/chat/model/message_model.dart';

class MessageSocket {
  final _controller = StreamController<MessageModel>.broadcast();

  final _userJoinController = StreamController<UserModel>.broadcast();

  Stream<MessageModel> get messages => _controller.stream;

  Stream<UserModel> get user => _userJoinController.stream;

  final AuthSocket _socket;

  MessageSocket({required AuthSocket socket}) : _socket = socket;

  void startListening() {
    _socket.on('message:update', (data) {
      try {
        final message = MessageModel.fromJson(data["message"]);
        _controller.add(message);
      } catch (e) {
        debugPrint("Message parse error: $e");
      }
    });

    _socket.on('room:user-joined', (data) {
      try {
        final user = UserModel.fromJson(data['user']);
        _userJoinController.add(user);
      } catch (e) {
        debugPrint("User parse error $e");
      }
    });
  }

  void stopListening() {
    _socket.off('message:update');
    _socket.off('room:user-joined');
  }

  void dispose() {
    _controller.close();
  }
}
