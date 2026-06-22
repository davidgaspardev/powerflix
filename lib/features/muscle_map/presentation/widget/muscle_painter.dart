import 'dart:ui';

import 'package:flutter/material.dart' show Color, CustomPainter, StrokeCap, StrokeJoin;
import 'package:moveflix/core/domain/models/muscle_stress.dart';
import 'package:moveflix/features/muscle_map/domain/models/figure_outline_path_data.dart';
import 'package:moveflix/features/muscle_map/domain/models/muscle_region_data.dart';

// SVG viewBox dimensions — both maps share the same canvas size.
const double kMuscleMapWidth = 661.0;
const double kMuscleMapHeight = 1207.0;
const double kMuscleMapAspectRatio = kMuscleMapWidth / kMuscleMapHeight;

class MusclePainter extends CustomPainter {
  final List<MuscleRegionData> regions;
  final FigureOutlinePathData? outline;
  final Map<String, MuscleStress> stress;

  const MusclePainter({
    required this.regions,
    required this.outline,
    required this.stress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / kMuscleMapWidth;

    canvas.save();
    canvas.scale(scale);

    if (outline != null) {
      canvas.drawPath(
        outline!.path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.46 / scale
          ..color = const Color(0x32646464)
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    for (final region in regions) {
      final level = stress[region.id] ?? MuscleStress.none;

      canvas.drawPath(
        region.path,
        Paint()
          ..style = PaintingStyle.fill
          ..color = _fillColor(level),
      );

      canvas.drawPath(
        region.path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2 / scale
          ..color = const Color(0x55000000),
      );
    }

    canvas.restore();
  }

  String? findMuscleAt(Offset tapPosition, Size canvasSize) {
    final scale = canvasSize.width / kMuscleMapWidth;
    final svgPoint = tapPosition / scale;

    for (final region in regions.reversed) {
      if (region.path.contains(svgPoint)) return region.id;
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
      old.regions != regions || old.outline != outline || old.stress != stress;
}
