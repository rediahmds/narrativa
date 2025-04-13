import 'package:flutter/material.dart';
import 'package:narrativa/screens/screens.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({
    super.key,
    required this.onRegister,
    required this.onLogin,
  });

  final Function onRegister;
  final Function onLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20,
            children: [
              Center(
                child: Column(
                  spacing: 20,
                  children: [
                    const Text("Welcome to Narrativa!"),
                    const Text("Let's register your account"),
                  ],
                ),
              ),
              RegisterForm(),
              FilledButton.tonal(
                onPressed: () => onRegister(),
                child: const Text('Register'),
              ),
              OutlinedButton(
                onPressed: () => onLogin(),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
