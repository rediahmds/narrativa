import 'package:flutter/material.dart';

class NarrativaTextField extends StatelessWidget {
  const NarrativaTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.textInputType,
    this.validator,
    this.hintText,
    this.obscureText,
    this.borderRadius,
  });

  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final TextInputType textInputType;
  final FormFieldValidator<String>? validator;
  final bool? obscureText;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12.0),
        ),
      ),
      keyboardType: textInputType,
      validator: validator,
      obscureText: obscureText ?? false,
    );
  }
}
