import 'package:flutter/material.dart';
import 'package:moveflix/shared/widgets/label.dart';

class Menu extends StatelessWidget {
  final VoidCallback onBodyMapTap;

  const Menu({super.key, required this.onBodyMapTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          onTap: onBodyMapTap,
          leading: const Icon(Icons.accessibility_new),
          title: Label('Mapa Muscular', fontWeight: FontWeight.w600),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
