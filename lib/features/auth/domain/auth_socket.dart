import 'package:flutter/foundation.dart';
import 'package:nomed/config/app_config.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class AuthSocket {
  AuthSocket._internal();

  static final AuthSocket _instance = AuthSocket._internal();

  factory AuthSocket() => _instance;

  io.Socket? _socket;

  io.Socket get socket {
    if (_socket == null) {
      throw Exception("Socket not initialized. Call connect() first.");
    }
    return _socket!;
  }

  bool get isConnected => _socket?.connected ?? false;

  void connect(String userId, {String? token}) {
    if (_socket != null && _socket!.connected) {
      debugPrint("Socket already connected");
      return;
    }

    _socket = io.io(
      AppConfig.apiSocketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .setAuth({
            'token': token ?? '',
            'userId': userId,
          })
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _registerEvents();
  }

  void _registerEvents() {
    _socket?.onConnect((_) {
      debugPrint("Socket connected");
    });

    _socket?.onDisconnect((reason) {
      debugPrint("Socket disconnected: $reason");
    });

    _socket?.onConnectError((data) {
      debugPrint("Socket connect error: $data");
    });

    _socket?.onReconnect((attempt) {
      debugPrint("Socket reconnected after $attempt attempts");
    });

    _socket?.onReconnectAttempt((attempt) {
      debugPrint("Reconnect attempt: $attempt");
    });
  }

  /// Generic emit method (important for reuse)
  void emit(String event, dynamic data) {
    if (_socket == null) return;
    _socket!.emit(event, data);
  }

  /// Generic listen method
  void on(String event, Function(dynamic) handler) {
    _socket?.on(event, handler);
  }

  void off(String event) {
    _socket?.off(event);
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}