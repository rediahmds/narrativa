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
    this.autovalidateMode,
    this.expands,
  });

  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final TextInputType textInputType;
  final FormFieldValidator<String>? validator;
  final bool? obscureText;
  final double? borderRadius;
  final AutovalidateMode? autovalidateMode;
  final bool? expands;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 16.0),
        ),
      ),
      keyboardType: textInputType,
      validator: validator,
      obscureText: obscureText ?? false,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
      expands: expands ?? false,
      maxLines: expands == true ? null : 1,
      minLines: expands == true ? null : 1,
      textAlignVertical: expands == true ? TextAlignVertical.top : null,
      textAlign: TextAlign.start,
    );
  }
}
