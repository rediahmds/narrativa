import 'package:flutter/material.dart';
import 'package:narrativa/ui/ui.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

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
      key: formKey,
      child: Column(
        spacing: 12,
        children: [
          NarrativaTextField(
            controller: nameController,
            labelText: "Name",
            hintText: "e.g. Kylian Mbappé",
            textInputType: TextInputType.name,
          ),
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
