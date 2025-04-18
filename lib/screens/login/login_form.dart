import 'package:flutter/material.dart';
import 'package:narrativa/models/models.dart';
import 'package:narrativa/providers/providers.dart';
import 'package:narrativa/static/static.dart';
import 'package:narrativa/ui/ui.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.onLogin, required this.onRegister});

  @override
  State<LoginForm> createState() => _LoginFormState();
  final Function onLogin;
  final Function onRegister;
}

class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 12,
        children: [
          NarrativaTextField(
            controller: emailController,
            labelText: "Email",
            hintText: "e.g. kylian.mbappe@gmail.com",
            textInputType: TextInputType.emailAddress,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) {
              if (email == null || email.isEmpty) {
                return 'Email cannot be empty';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
                return 'Invalid email format';
              }
              return null;
            },
          ),
          NarrativaTextField(
            controller: passwordController,
            labelText: "Password",
            hintText: "Must be at least 8 characters",
            textInputType: TextInputType.visiblePassword,
            obscureText: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (password) {
              if (password == null || password.isEmpty) {
                return 'Password is required';
              }
              if (password.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              return null;
            },
          ),
          Consumer<SessionProvider>(
            builder: (_, sessionProvider, _) {
              switch (sessionProvider.state.status) {
                case SessionStatus.loadingLogin:
                  return const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: CircularProgressIndicator(),
                  );

                default:
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 12,
                    children: [
                      FilledButton(
                        onPressed: () async {
                          final payload = LoginPayload(
                            email: emailController.text,
                            password: passwordController.text,
                          );

                          final isLoggedIn = await sessionProvider.login(
                            payload,
                          );

                          if (isLoggedIn) {
                            widget.onLogin();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  sessionProvider.state.errorMessage ??
                                      "Unknown error",
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('Login'),
                      ),
                      OutlinedButton(
                        onPressed: () => widget.onRegister(),
                        child: const Text("Register"),
                      ),
                    ],
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}
