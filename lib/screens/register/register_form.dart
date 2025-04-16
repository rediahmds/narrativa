import 'package:flutter/material.dart';
import 'package:narrativa/models/models.dart';
import 'package:narrativa/ui/ui.dart';
import 'package:provider/provider.dart';
import 'package:narrativa/providers/providers.dart';
import 'package:narrativa/static/static.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
    required this.onRegister,
    required this.onLogin,
  });

  final Function onRegister;
  final Function onLogin;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 12,
        children: [
          NarrativaTextField(
            controller: nameController,
            labelText: "Name",
            hintText: "e.g. Kylian Mbappé",
            textInputType: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name cannot be empty';
              }

              return null;
            },
          ),
          NarrativaTextField(
            controller: emailController,
            labelText: "Email",
            hintText: "e.g. kylian.mbappe@gmail.com",
            textInputType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email cannot be empty';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
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
            validator: (password) {
              if (password == null || password.isEmpty) {
                return 'Password is required';
              }
              if (password.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          Consumer<SessionProvider>(
            builder: (_, sessionProvider, _) {
              final sessionStatus = sessionProvider.state.status;

              if (sessionStatus == SessionStatus.loadingLogin ||
                  sessionStatus == SessionStatus.loadingRegister) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton(
                    onPressed: () async {
                      final payload = RegisterPayload(
                        name: nameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                      );

                      await sessionProvider.register(payload);
                      debugPrint(
                        "Session status: ${sessionProvider.state.status}",
                      );

                      if (sessionProvider.state.status ==
                          SessionStatus.loggedIn) {
                        widget.onRegister();
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
                    child: const Text('Register'),
                  ),
                  TextButton(
                    onPressed: () => widget.onLogin(),
                    child: const Text('Login'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
