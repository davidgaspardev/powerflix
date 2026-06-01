import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  static const double height = 61;

  final VoidCallback onTap;

  const Header({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(color: Colors.white),
      child: GestureDetector(
        onTap: onTap,
        child: Image.asset('lib/app/assets/image/logo.png', height: 45),
      ),
    );
  }
}
