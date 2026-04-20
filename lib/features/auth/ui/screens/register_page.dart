import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomed/components/custom_button.dart';
import 'package:nomed/components/custom_text_field.dart';
import 'package:nomed/features/auth/bloc/auth_cubit.dart';
import 'package:nomed/features/auth/bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage(this.onSwitch, {super.key});
  final void Function() onSwitch;

  @override
  State<RegisterPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPage> {
  final TextEditingController _passwrodController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameContrller = TextEditingController();

  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("Register Page"), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                Center(
                  child: Text(
                    "Nomed".toUpperCase(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                CustomTextField(
                  title: "username",
                  textEditingController: _usernameContrller,
                  hintText: "Eneter username here",
                ),
                SizedBox(height: 20),
                CustomTextField(
                  title: "Emial",
                  textEditingController: _emailController,
                  hintText: "Eneter email here",
                ),
                SizedBox(height: 20),
                CustomTextField(
                  title: "Password",
                  hintText: "Enter Password here",

                  maxLines: 1,
                  obscureText: _hidePassword,
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        _hidePassword = !_hidePassword;
                      });
                    },
                    child: Icon(
                      _hidePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility,
                    ),
                  ),
                  textEditingController: _passwrodController,
                ),

                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have account? "),
                    TextButton(
                      onPressed: () {
                        widget.onSwitch();
                      },
                      child: Text("Sign in"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButton(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                      .copyWith(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
                      ),
                  onTap: isLoading ? null : () => _regiter(),
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (_) => AppNavigation()),
                  // );
                  // },
                  buttonColor: isLoading
                      ? theme.disabledColor
                      : theme.primaryColor,
                  text: "Continue",
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _regiter() {
    if (_emailController.text.isEmpty ||
        _usernameContrller.text.isEmpty ||
        _passwrodController.text.isEmpty) {
      return;
    }

    context.read<AuthCubit>().register(
      _emailController.text.trim(),
      _usernameContrller.text.trim(),
      _passwrodController.text.trim(),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
    _passwrodController.dispose();
    _usernameContrller.dispose();
  }
}
