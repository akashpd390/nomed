import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nomed/config/app_config.dart';
import 'package:nomed/core/constents.dart';
import 'package:nomed/features/auth/domain/auith_network.dart';
import 'package:nomed/features/auth/domain/auth_repository.dart';
import 'package:nomed/features/auth/domain/auth_socket.dart';
import 'package:nomed/features/chat/domain/message_network.dart';
import 'package:nomed/features/chat/domain/message_socket.dart';
import 'package:nomed/shared/network/room_network.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  await _registerCore();
  _registerAuth();
  _registerOtherDependency();
}

Future<void> _registerCore() async {
  // SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // Dio
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // Interceptors
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add token from SharedPreferences
        final token = prefs.getString(Constants.tokenKey);
        // print("tokkkkkkkkkkkken $token");
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          // Token expired or invalid → handle logout
          await getIt<AuthRepository>().logout();
        }
        return handler.next(e);
      },
    ),
  );

  // Pretty logging for debugging
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ),
  );

  getIt.registerSingleton<Dio>(dio);
}

void _registerAuth() {
  getIt.registerLazySingleton<AuthNetwork>(() => AuthNetwork(getIt<Dio>()));

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<AuthNetwork>(), getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<AuthSocket>(() => AuthSocket());
}

void _registerOtherDependency() {
  getIt.registerLazySingleton<RoomNetwork>(() => RoomNetwork(getIt<Dio>()));

  getIt.registerLazySingleton<MessageNetwork>(
    () => MessageNetwork(getIt<Dio>()),
  );

  getIt.registerLazySingleton<MessageSocket>(
    () => MessageSocket(socket: getIt<AuthSocket>()),
  );
}
