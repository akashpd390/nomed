
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomed/components/custom_button.dart';
import 'package:nomed/components/custom_text_field.dart';
import 'package:nomed/features/auth/bloc/auth_cubit.dart';
import 'package:nomed/features/auth/bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage(this.onSwitch, {super.key});

  final void Function() onSwitch;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwrodController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Login Page")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
            
              // crossAxisAlignment: CrossAxisAlignment.center,
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
            
                Center(
                  child: CustomTextField(
                    title: "Emial",
                    textEditingController: _emailController,
                    hintText: "Eneter email here",
                  ),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
            
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("dont have an account? "),
                    TextButton(
                      onPressed: () {
                        widget.onSwitch.call();
                      },
                      child: Text("Create "),
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
                  onTap: () => isLoading ? null : _login(),
                  buttonColor: isLoading
                      ? theme.disabledColor
                      : theme.primaryColor,
                  borderColor: isLoading
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

  void _login() {
    if (_emailController.text.isEmpty || _passwrodController.text.isEmpty) {
      return;
    }

    context.read<AuthCubit>().login(
      _emailController.text.trim(),
      _passwrodController.text.trim(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwrodController.dispose();
  }
}
