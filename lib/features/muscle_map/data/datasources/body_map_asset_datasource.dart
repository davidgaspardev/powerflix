import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:powerflix/core/domain/models/body_sex.dart';
import 'package:powerflix/features/muscle_map/domain/models/body_side.dart';
import 'package:powerflix/features/muscle_map/domain/models/figure_outline_path_data.dart';
import 'package:powerflix/features/muscle_map/domain/models/muscle_region_data.dart';
import 'package:xml/xml.dart';

typedef BodyMapData = ({
  List<MuscleRegionData> regions,
  FigureOutlinePathData outline,
});

class BodyMapAssetDatasource {
  static const Map<BodySide, Map<BodySex, String>> _assets = {
    BodySide.front: {
      BodySex.male: 'assets/image/svg/male_muscle_map_front.svg',
      BodySex.female: 'assets/image/svg/female_muscle_map_front.svg',
    },
    BodySide.back: {
      BodySex.male: 'assets/image/svg/male_muscle_map_back.svg',
      BodySex.female: 'assets/image/svg/female_muscle_map_back.svg',
    },
  };

  Future<BodyMapData> load({required BodySide side, required BodySex sex}) async {
    final raw = await rootBundle.loadString(_assets[side]![sex]!);
    return _parse(raw);
  }

  BodyMapData _parse(String svg) {
    final doc = XmlDocument.parse(svg);
    final regions = <MuscleRegionData>[];
    final outlinePath = Path();

    for (final el in doc.findAllElements('path')) {
      final id = el.getAttribute('id');
      final d = el.getAttribute('d');
      if (d == null) continue;

      final stroke = el.getAttribute('stroke');

      if (id != null && id.startsWith('muscle_')) {
        regions.add(MuscleRegionData(id: id, path: parseSvgPathData(d)));
      } else if (stroke?.toUpperCase() == '#FF0000') {
        // Body figure outline — non-interactive, stroke #FF0000 in SVG.
        outlinePath.addPath(parseSvgPathData(d), Offset.zero);
      }
    }

    return (regions: regions, outline: FigureOutlinePathData(path: outlinePath));
  }
}
