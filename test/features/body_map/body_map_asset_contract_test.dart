import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:moveflix/core/domain/models/body_region.dart';
import 'package:moveflix/core/domain/models/region_side.dart';
import 'package:moveflix/features/body_map/data/datasources/body_map_asset_datasource.dart';

/// Regions each view is expected to expose. The male and female art must
/// agree exactly — nothing downstream branches on sex, so a region present
/// on one body and missing on the other silently fails to shade.
const _frontRegions = {
  BodyRegion.neck,
  BodyRegion.traps,
  BodyRegion.frontShoulder,
  BodyRegion.chest,
  BodyRegion.frontUpperArm,
  BodyRegion.forearm,
  BodyRegion.abdomen,
  BodyRegion.flank,
  BodyRegion.quads,
  BodyRegion.shin,
};

const _backRegions = {
  BodyRegion.traps,
  BodyRegion.backShoulder,
  BodyRegion.upperBack,
  BodyRegion.lowerBack,
  BodyRegion.lats,
  BodyRegion.backUpperArm,
  BodyRegion.forearm,
  BodyRegion.glutes,
  BodyRegion.hamstrings,
  BodyRegion.calves,
};

const _dir = 'assets/image/svg';

Set<BodyRegion> _regionsOf(String file) {
  final svg = File('$_dir/$file').readAsStringSync();
  return BodyMapAssetDatasource().parse(svg).regions.map((r) => r.region).toSet();
}

Set<String> _idsOf(String file) {
  final svg = File('$_dir/$file').readAsStringSync();
  return BodyMapAssetDatasource()
      .parse(svg)
      .regions
      .map((r) => '${r.region.svgId}${r.side.svgSuffix}')
      .toSet();
}

void main() {
  group('body map assets', () {
    test('front view exposes exactly the front regions, male and female', () {
      expect(_regionsOf('male_muscle_map_front.svg'), _frontRegions);
      expect(_regionsOf('female_muscle_map_front.svg'), _frontRegions);
    });

    test('back view exposes exactly the back regions, male and female', () {
      expect(_regionsOf('male_muscle_map_back.svg'), _backRegions);
      expect(_regionsOf('female_muscle_map_back.svg'), _backRegions);
    });

    test('male and female share identical region ids per view', () {
      expect(
        _idsOf('male_muscle_map_front.svg'),
        _idsOf('female_muscle_map_front.svg'),
      );
      expect(
        _idsOf('male_muscle_map_back.svg'),
        _idsOf('female_muscle_map_back.svg'),
      );
    });

    test('paired regions are drawn on both sides', () {
      for (final file in [
        'male_muscle_map_front.svg',
        'female_muscle_map_front.svg',
        'male_muscle_map_back.svg',
        'female_muscle_map_back.svg',
      ]) {
        final svg = File('$_dir/$file').readAsStringSync();
        final sidesByRegion = <BodyRegion, Set<RegionSide>>{};
        for (final r in BodyMapAssetDatasource().parse(svg).regions) {
          sidesByRegion.putIfAbsent(r.region, () => {}).add(r.side);
        }
        sidesByRegion.forEach((region, sides) {
          if (sides.contains(RegionSide.left) || sides.contains(RegionSide.right)) {
            expect(
              sides.containsAll({RegionSide.left, RegionSide.right}),
              isTrue,
              reason: '$file: ${region.svgId} is missing a side ($sides)',
            );
          }
        });
      }
    });

    test('every region id in the assets maps to a known BodyRegion', () {
      // A typo in an id would make the path silently fall through to the
      // outline instead of becoming a shadeable region.
      for (final file in [
        'male_muscle_map_front.svg',
        'female_muscle_map_front.svg',
        'male_muscle_map_back.svg',
        'female_muscle_map_back.svg',
      ]) {
        final svg = File('$_dir/$file').readAsStringSync();
        final idsInFile = RegExp(r'id="([a-z_]+)"')
            .allMatches(svg)
            .map((m) => m.group(1)!)
            .toSet();
        final resolved = _idsOf(file);
        expect(
          idsInFile.difference(resolved),
          isEmpty,
          reason: '$file has region-looking ids that BodyRegion does not know',
        );
      }
    });
  });
}
