import 'package:flutter/material.dart';
import 'package:moveflix/core/domain/models/muscle_stress.dart';
import 'package:moveflix/features/body_map/presentation/widget/muscle_painter.dart';

class StressLegend extends StatelessWidget {
  const StressLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: MuscleStress.values
          .where((s) => s != MuscleStress.none)
          .map((s) => _LegendItem(level: s))
          .toList(),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final MuscleStress level;

  const _LegendItem({required this.level});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: MusclePainter.stressColor(level),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            level.name[0].toUpperCase() + level.name.substring(1),
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
