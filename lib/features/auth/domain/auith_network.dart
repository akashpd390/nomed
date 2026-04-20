import 'package:dio/dio.dart';
import 'package:nomed/features/auth/model/user_model.dart';

class AuthResponse {
  final UserModel user;
  final String token;

  AuthResponse({required this.user, required this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: UserModel.fromJson(json["user"]),
      token: json["token"] ?? "",
    );
  }
}

class AuthNetwork {
  final Dio dio;

  AuthNetwork(this.dio);

  Future<AuthResponse> register({
    required String email,
    required String username,
    required String password,
  }) async {
    final response = await dio.post(
      '/auth/register',
      data: {'email': email, 'username': username, 'password': password},
    );
    return AuthResponse.fromJson(response.data);
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    return AuthResponse.fromJson(response.data);
  }

  Future<bool> verifyToken() async {
    try {
      final response = await dio.get('/auth/verify');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
