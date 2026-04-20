import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomed/features/auth/domain/auth_repository.dart';
import 'package:nomed/features/auth/domain/auth_socket.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;
  final AuthSocket socket;

  AuthCubit(this.repository, this.socket) : super(AuthInitial());

  Future<void> checkAuth() async {
    final user = repository.getUser();
    final token = repository.getToken();
    if (user != null && token != null && token.isNotEmpty) {
      bool isValid = await repository.verifyToken();
      if (isValid) {
        emit(AuthAuthenticated(user));
        socket.connect(user.id, token: token);
      } else {
        await logout();
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  String? get userId {
    final state = this.state;
    if (state is AuthAuthenticated) {
      return state.user.id;
    }
    return null;
  }

  Future<void> register(String email, String username, String password) async {
    emit(AuthLoading());
    try {
      final user = await repository.register(email, username, password);
      emit(AuthAuthenticated(user));
      socket.connect(user.id, token: repository.getToken());
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await repository.login(email, password);
      emit(AuthAuthenticated(user));
      debugPrint("emiting the authatuhncate");
      socket.connect(user.id, token: repository.getToken());
    } catch (e) {
      emit(AuthError(e.toString()));
      // emit(AuthUnauthenticated());
    }
  }

  Future<void> logout() async {
    socket.disconnect();
    await repository.logout();
    emit(AuthUnauthenticated());
  }
}
