import 'package:flutter/material.dart';

class FieldText extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final FormFieldValidator<String>? validator;

  const FieldText({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
  });

  static const _border = OutlineInputBorder(borderSide: BorderSide.none);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      validator: validator,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        labelText: label,
        hintText: hintText,
        errorStyle: const TextStyle(fontSize: 12, height: -0.1),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: _border,
        enabledBorder: _border,
        focusedBorder: _border,
      ),
    );
  }
}
