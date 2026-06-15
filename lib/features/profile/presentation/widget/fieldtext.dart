import 'package:flutter/material.dart';

class FieldText extends StatelessWidget {
  final TextEditingController controller;

  const FieldText({
    required super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
    );
  }
}
