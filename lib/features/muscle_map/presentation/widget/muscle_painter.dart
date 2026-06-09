import 'dart:ui';

import 'package:flutter/material.dart' show Color, CustomPainter;
import 'package:powerflix/core/domain/models/muscle_stress.dart';
import 'package:powerflix/features/muscle_map/domain/models/muscle_path_data.dart';

// SVG viewBox dimensions — both maps share the same canvas size.
const double kMuscleMapWidth = 661.0;
const double kMuscleMapHeight = 1207.0;
const double kMuscleMapAspectRatio = kMuscleMapWidth / kMuscleMapHeight;

class MusclePainter extends CustomPainter {
  final List<MusclePathData> paths;
  final Map<String, MuscleStress> stress;

  const MusclePainter({required this.paths, required this.stress});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / kMuscleMapWidth;

    canvas.save();
    canvas.scale(scale);

    for (final muscle in paths) {
      final level = stress[muscle.id] ?? MuscleStress.none;

      canvas.drawPath(muscle.path, Paint()
        ..style = PaintingStyle.fill
        ..color = _fillColor(level));

      canvas.drawPath(muscle.path, Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2 / scale
        ..color = const Color(0x55000000));
    }

    canvas.restore();
  }

  // Returns the muscle hit at [tapPosition] in widget (scaled) coordinates,
  // or null if no muscle was tapped.
  String? findMuscleAt(Offset tapPosition, Size canvasSize) {
    final scale = canvasSize.width / kMuscleMapWidth;
    final svgPoint = tapPosition / scale;

    // Iterate in reverse so top-rendered paths (drawn last) take priority.
    for (final muscle in paths.reversed) {
      if (muscle.path.contains(svgPoint)) return muscle.id;
    }
    return null;
  }

  static Color _fillColor(MuscleStress level) {
    switch (level) {
      case MuscleStress.none:   return const Color(0xFFBDBDBD);
      case MuscleStress.low:    return const Color(0xFFFFEE58);
      case MuscleStress.medium: return const Color(0xFFFF9800);
      case MuscleStress.high:   return const Color(0xFFE53935);
    }
  }

  static Color stressColor(MuscleStress level) => _fillColor(level);

  @override
  bool shouldRepaint(MusclePainter old) =>
      old.paths != paths || old.stress != stress;
}
