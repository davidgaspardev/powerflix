import 'dart:ui';

import 'package:flutter/material.dart' show Color, CustomPainter, StrokeCap, StrokeJoin;
import 'package:moveflix/core/domain/models/body_region.dart';
import 'package:moveflix/core/domain/models/stress_level.dart';
import 'package:moveflix/features/body_map/domain/models/body_region_data.dart';
import 'package:moveflix/features/body_map/domain/models/figure_outline_path_data.dart';

// SVG viewBox dimensions — all four maps share the same canvas size.
const double kBodyMapWidth = 661.0;
const double kBodyMapHeight = 1207.0;
const double kBodyMapAspectRatio = kBodyMapWidth / kBodyMapHeight;

class BodyMapPainter extends CustomPainter {
  final List<BodyRegionData> regions;
  final FigureOutlinePathData? outline;
  final Map<BodyRegion, int> stressByRegion;

  const BodyMapPainter({
    required this.regions,
    required this.outline,
    required this.stressByRegion,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / kBodyMapWidth;

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
      final level = StressLevel.fromLevel(stressByRegion[region.region] ?? 0);

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

  static Color _fillColor(StressLevel level) {
    switch (level) {
      case StressLevel.none:   return const Color(0xFFBDBDBD);
      case StressLevel.low:    return const Color(0xFFFFEE58);
      case StressLevel.medium: return const Color(0xFFFF9800);
      case StressLevel.high:   return const Color(0xFFE53935);
    }
  }

  static Color stressColor(StressLevel level) => _fillColor(level);

  @override
  bool shouldRepaint(BodyMapPainter old) =>
      old.regions != regions ||
      old.outline != outline ||
      old.stressByRegion != stressByRegion;
}
