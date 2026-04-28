import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomed/features/auth/model/user_model.dart';
import 'package:nomed/features/chat/bloc/message_state.dart';
import 'package:nomed/features/chat/domain/message_network.dart';
import 'package:nomed/features/chat/domain/message_socket.dart';
import 'package:nomed/features/chat/model/message_model.dart';

class MessageCubit extends Cubit<MessageState> {
  final MessageNetwork api;
  final MessageSocket messageSocket;
  StreamSubscription? socketSub;
  List<MessageModel> _messages = [];
  StreamSubscription? _userSubs;

  UserModel? _user;

  int _currentPage = 1;
  int _totalPages = 1;
  bool _isFetching = false;

  MessageCubit(this.api, this.messageSocket)
    : super(MessageState(isLoading: true)) {
    messageSocket.startListening();
    _startListening();
    _starLisningUserJoins();
  }

  Future<void> _starLisningUserJoins() async {
    try {
      _userSubs = messageSocket.user.listen((user) {
        _user = user;
        if (_user != null) {
          emit(state.copyWith(joinedUser: _user));
        }
        emit(state.copyWith(joinedUser: null));
      });
    } catch (e) {
      emit(MessageState(error: e.toString()));
    }
  }

  Future<void> fetchInitialMessages(String roomId, int limit) async {
    _currentPage = 1;
    _totalPages = 1;
    _messages.clear();

    emit(MessageState(isLoading: true));

    try {
      final result = await api.fethcMessage(
        roomId,
        limit: limit,
        page: _currentPage,
      );

      _totalPages = result.totalPages;
      _messages = result.messages;

      emit(MessageState(messages: _messages));
      _currentPage++;
    } catch (e) {
      emit(MessageState(error: e.toString()));
    }
  }

  Future<void> fetchMore(String roomId, int limit) async {
    if (_isFetching) return;
    if (_currentPage > _totalPages) return;

    try {
      _isFetching = true;

      final result = await api.fethcMessage(
        roomId,
        limit: limit,
        page: _currentPage,
      );

      _messages = [...result.messages, ..._messages];

      emit(MessageState(messages: _messages));

      _currentPage++;
    } catch (e) {
      emit(MessageState(error: e.toString()));
    } finally {
      _isFetching = false;
    }
  }

  Future<void> _startListening() async {
    try {
      socketSub = messageSocket.messages.listen((messModel) {
        _messages = List.from(_messages)..add(messModel);
        emit(MessageState(messages: _messages));
      });
    } catch (e) {
      emit(MessageState(error: e.toString()));
    }
  }

  Future<void> sendMessage(String roomId, String content) async {
    try {
      // emit(MessageSendingState(_messages));
      await api.sendMessage(roomId, content);
      // _messages.add(result);
      // emit(MessageState(_messages));
    } catch (e) {
      emit(MessageState(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    socketSub?.cancel();
    messageSocket.stopListening();
    _userSubs?.cancel();
    return super.close();
  }
}
