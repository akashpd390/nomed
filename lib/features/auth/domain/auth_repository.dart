import 'dart:convert';

import 'package:nomed/core/constents.dart';
import 'package:nomed/features/auth/domain/auith_network.dart';
import 'package:nomed/features/auth/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final AuthNetwork api;
  final SharedPreferences prefs;

  AuthRepository(this.api, this.prefs);

  Future<UserModel> login(String email, String password) async {
    final response = await api.login(email: email, password: password);

    await prefs.setString(Constants.tokenKey, response.token);
    final write = await prefs.setString(
      Constants.userKey,
      jsonEncode(response.user.toJson()),
    );


    return response.user;
  }

  Future<UserModel> register(String email, String username ,String password)async{
    final response = await api.register(email: email, username: username, password: password);
    await prefs.setString(Constants.tokenKey, response.token);
    await prefs.setString(Constants.userKey, jsonEncode(response.user));
    return response.user;

  }

  String? getToken() => prefs.getString(Constants.tokenKey);

  Future<bool> verifyToken() async {
    return await api.verifyToken();
  }

  UserModel? getUser() {
    final userJson = prefs.getString(Constants.userKey);
    if (userJson == null) return null;

    return UserModel.fromJson(jsonDecode(userJson));
  }

  Future<void> logout() async {
    await prefs.remove(Constants.tokenKey);
    await prefs.remove(Constants.userKey);
  }
}
