import 'package:nomed/features/auth/model/user_model.dart';
import 'package:nomed/features/chat/model/message_model.dart';

class MessageState {
  final List<MessageModel> messages;
  final bool isLoading;
  final String? error;

  /// transient event (for toast)
  final UserModel? joinedUser;

  const MessageState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.joinedUser,
  });

  MessageState copyWith({
    List<MessageModel>? messages,
    bool? isLoading,
    String? error,
    UserModel? joinedUser,
  }) {
    return MessageState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      joinedUser: joinedUser,
    );
  }
}