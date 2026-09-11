import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:moveflix/core/domain/models/body_region.dart';
import 'package:moveflix/core/domain/models/body_sex.dart';
import 'package:moveflix/core/domain/models/region_side.dart';
import 'package:moveflix/features/body_map/domain/models/body_region_data.dart';
import 'package:moveflix/features/body_map/domain/models/body_side.dart';
import 'package:moveflix/features/body_map/domain/models/figure_outline_path_data.dart';
import 'package:xml/xml.dart';

typedef BodyMapData = ({
  List<BodyRegionData> regions,
  FigureOutlinePathData outline,
});

/// Reads the body map SVGs and splits them into shadeable [BodyRegionData]
/// and the non-interactive figure outline.
///
/// Region paths carry an `id` of `<region>` (midline) or `<region>_left` /
/// `<region>_right` (paired); the outline and detail strokes carry
/// `stroke="#FF0000"` and no id. The four assets expose the same region ids
/// per view for both sexes — only the shapes differ. See
/// `lib/features/body_map/README.md`.
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

  static const _outlineStroke = '#FF0000';

  Future<BodyMapData> load({required BodySide side, required BodySex sex}) async {
    final raw = await rootBundle.loadString(_assets[side]![sex]!);
    return parse(raw);
  }

  @visibleForTesting
  BodyMapData parse(String svg) {
    final doc = XmlDocument.parse(svg);
    final regions = <BodyRegionData>[];
    final outlinePath = Path();

    for (final el in doc.findAllElements('path')) {
      final d = el.getAttribute('d');
      if (d == null) continue;

      final id = el.getAttribute('id');
      if (id != null) {
        final region = _parseRegion(id, d);
        if (region != null) {
          regions.add(region);
          continue;
        }
      }

      if (el.getAttribute('stroke')?.toUpperCase() == _outlineStroke) {
        outlinePath.addPath(parseSvgPathData(d), Offset.zero);
      }
    }

    return (regions: regions, outline: FigureOutlinePathData(path: outlinePath));
  }

  BodyRegionData? _parseRegion(String id, String d) {
    var name = id;
    var side = RegionSide.center;

    for (final paired in const [RegionSide.left, RegionSide.right]) {
      if (name.endsWith(paired.svgSuffix)) {
        side = paired;
        name = name.substring(0, name.length - paired.svgSuffix.length);
        break;
      }
    }

    final region = BodyRegion.fromSvgId(name);
    if (region == null) return null;

    return BodyRegionData(
      region: region,
      side: side,
      path: parseSvgPathData(d),
    );
  }
}
