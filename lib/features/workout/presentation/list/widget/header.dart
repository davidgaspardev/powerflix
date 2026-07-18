import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Header extends StatelessWidget {
  static const double height = 61;

  final VoidCallback onMenuTap;
  final String username;
  final bool isOpen;

  const Header({
    super.key,
    required this.username,
    required this.onMenuTap,
    this.isOpen = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height,
      decoration: BoxDecoration(color: theme.colorScheme.surface),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: height, height: height),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/image/svg/logo.svg', height: 50),
                      Container(
                        height: 35,
                        width: 1,
                        color: Colors.grey[300],
                        margin: const EdgeInsets.only(left: 8, right: 16),
                      ),
                      Text(
                        'Olá $username',
                        style: const TextStyle(color: Color(0xFF494547)),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onMenuTap,
                  child: SizedBox(
                    width: height,
                    height: height,
                    child: AnimatedRotation(
                      turns: isOpen ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 32,
                        color: Color(0xFF494547),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: Colors.grey[300]),
        ],
      ),
    );
  }
}
