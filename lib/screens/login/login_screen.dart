import 'package:flutter/material.dart';
import 'package:narrativa/screens/screens.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

  final Function onLogin;
  final Function onRegister;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20,
            children: [
              Center(child: const Text('Welcome to Narrativa!')),
              LoginForm(),
              FilledButton(
                onPressed: () => onLogin(),
                child: const Text('Login'),
              ),
              OutlinedButton(
                onPressed: () => onRegister(),
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
