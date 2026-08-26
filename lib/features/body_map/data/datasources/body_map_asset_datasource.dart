import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:moveflix/core/domain/models/body_sex.dart';
import 'package:moveflix/core/domain/models/muscle_group.dart';
import 'package:moveflix/core/domain/models/muscle_side.dart';
import 'package:moveflix/features/body_map/domain/models/body_side.dart';
import 'package:moveflix/features/body_map/domain/models/figure_outline_path_data.dart';
import 'package:moveflix/features/body_map/domain/models/muscle_region_data.dart';
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

  // SVG path id roots (after stripping `muscle_`/`left_`/`right_`) mapped to
  // the shared MuscleGroup identity — see assets/image/svg/*_muscle_map_*.svg.
  static const Map<String, MuscleGroup> _muscleGroupsByRoot = {
    'anterior_deltoid': MuscleGroup.anteriorDeltoid,
    'bicep': MuscleGroup.bicep,
    'forearm': MuscleGroup.forearm,
    'gastrocnemius': MuscleGroup.gastrocnemius,
    'gluteus_maximus': MuscleGroup.gluteusMaximus,
    'hamstring': MuscleGroup.hamstring,
    'infraspinatus': MuscleGroup.infraspinatus,
    'latissimus_dorsi': MuscleGroup.latissimusDorsi,
    'lower_leg': MuscleGroup.lowerLeg,
    'neck': MuscleGroup.neck,
    'obliques': MuscleGroup.obliques,
    'pectoralis': MuscleGroup.pectoralis,
    'posterior_deltoid': MuscleGroup.posteriorDeltoid,
    'quadriceps': MuscleGroup.quadriceps,
    'rectus_abdominis': MuscleGroup.rectusAbdominis,
    'rhomboids': MuscleGroup.rhomboids,
    'serratus_anterior': MuscleGroup.serratusAnterior,
    'trapezius_lower': MuscleGroup.trapeziusLower,
    'trapezius_mid': MuscleGroup.trapeziusMid,
    'trapezius_upper': MuscleGroup.trapeziusUpper,
    'tricep': MuscleGroup.tricep,
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
        final region = _parseRegion(id, d);
        if (region != null) regions.add(region);
      } else if (stroke?.toUpperCase() == '#FF0000') {
        // Body figure outline — non-interactive, stroke #FF0000 in SVG.
        outlinePath.addPath(parseSvgPathData(d), Offset.zero);
      }
    }

    return (regions: regions, outline: FigureOutlinePathData(path: outlinePath));
  }

  MuscleRegionData? _parseRegion(String id, String d) {
    var root = id.substring('muscle_'.length);
    var side = MuscleSide.center;

    if (root.startsWith('left_')) {
      side = MuscleSide.left;
      root = root.substring('left_'.length);
    } else if (root.startsWith('right_')) {
      side = MuscleSide.right;
      root = root.substring('right_'.length);
    }

    final muscleGroup = _muscleGroupsByRoot[root];
    if (muscleGroup == null) return null;

    return MuscleRegionData(
      muscleGroup: muscleGroup,
      side: side,
      path: parseSvgPathData(d),
    );
  }
}
