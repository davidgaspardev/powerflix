import 'package:flutter/material.dart';
import 'package:moveflix/shared/theme/colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      surface: Color(0xFFF1EDE9),
      brightness: Brightness.light,
    ),
  );
}