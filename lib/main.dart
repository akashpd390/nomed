import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nomed/config/style.dart';
import 'package:nomed/core/service_locator.dart';
import 'package:nomed/features/auth/bloc/auth_cubit.dart';
import 'package:nomed/features/auth/domain/auth_repository.dart';
import 'package:nomed/features/auth/domain/auth_socket.dart';
import 'package:nomed/features/auth/ui/screens/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AuthCubit(getIt<AuthRepository>(), getIt<AuthSocket>())
            ..checkAuth(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: appTheme,

        debugShowCheckedModeBanner: false,
        home: AuthGate(),
      ),
    );
  }
}
