import 'package:flutter/material.dart';
import 'package:narrativa/ui/ui.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
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
          ),
          NarrativaTextField(
            controller: passwordController,
            labelText: "Password",
            hintText: "Must be at least 8 characters",
            textInputType: TextInputType.visiblePassword,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 8) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
