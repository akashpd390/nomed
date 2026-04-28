import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomed/features/auth/bloc/auth_cubit.dart';
import 'package:nomed/features/auth/bloc/auth_state.dart';
import 'package:nomed/features/auth/ui/screens/register_page.dart';
import 'package:nomed/features/navigation/app_navigation.dart';
import 'login_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool showRegister = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AuthAuthenticated) {
          return const AppNavigation(key: ValueKey("app-nav"));
        }

        if (state is AuthError){
          debugPrint(state.message);
          
        }

        return showRegister
            ? RegisterPage(
                () => setState(() {
                  showRegister = false;
                }),
                key: ValueKey("register"),
              )
            : LoginPage(
                () => setState(() {
                  showRegister = true;
                }),
                key: ValueKey("login"),
              );
      },
    );
  }
}
