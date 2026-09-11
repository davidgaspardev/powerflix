import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:moveflix/core/domain/models/body_sex.dart';
import 'package:moveflix/core/domain/models/body_region.dart';
import 'package:moveflix/core/domain/models/region_side.dart';
import 'package:moveflix/features/body_map/domain/models/body_side.dart';
import 'package:moveflix/features/body_map/domain/models/figure_outline_path_data.dart';
import 'package:moveflix/features/body_map/domain/models/body_region_data.dart';
import 'package:moveflix/features/body_map/domain/repositories/body_map_repository.dart';
import 'package:moveflix/features/body_map/presentation/body_map_viewmodel.dart';

// ── fakes ──────────────────────────────────────────────────────────────────

class _FakeRepository implements BodyMapRepository {
  final List<BodyRegionData> frontRegions;
  final List<BodyRegionData> backRegions;
  int callCount = 0;

  _FakeRepository({required this.frontRegions, required this.backRegions});

  @override
  Future<List<BodyRegionData>> getRegions({
    required BodySide side,
    required BodySex sex,
  }) async {
    callCount++;
    return side == BodySide.front ? frontRegions : backRegions;
  }

  @override
  Future<FigureOutlinePathData> getFigureOutline({
    required BodySide side,
    required BodySex sex,
  }) async =>
      FigureOutlinePathData(path: Path());
}

BodyRegionData _fakeRegion(BodyRegion region, {RegionSide side = RegionSide.center}) =>
    BodyRegionData(region: region, side: side, path: Path());

// ── tests ──────────────────────────────────────────────────────────────────

void main() {
  group('BodyMapViewModel', () {
    test('init loads front regions and clears loading state', () async {
      final repo = _FakeRepository(
        frontRegions: [_fakeRegion(BodyRegion.chest, side: RegionSide.left)],
        backRegions: [],
      );
      final vm = BodyMapViewModel(repo);

      expect(vm.isLoading, isTrue);

      await vm.init();

      expect(vm.isLoading, isFalse);
      expect(vm.hasError, isFalse);
      expect(vm.regions, hasLength(1));
      expect(vm.regions.first.region, BodyRegion.chest);
      expect(vm.regions.first.side, RegionSide.left);
      expect(vm.side, BodySide.front);
    });

    test('toggleSide switches to back and reloads regions', () async {
      final repo = _FakeRepository(
        frontRegions: [_fakeRegion(BodyRegion.chest)],
        backRegions: [
          _fakeRegion(BodyRegion.upperBack),
          _fakeRegion(BodyRegion.lats),
        ],
      );
      final vm = BodyMapViewModel(repo);
      await vm.init();

      await vm.toggleSide();

      expect(vm.side, BodySide.back);
      expect(vm.regions, hasLength(2));
      expect(vm.regions.first.region, BodyRegion.upperBack);
    });

    test('toggleSide twice returns to front regions', () async {
      final repo = _FakeRepository(
        frontRegions: [_fakeRegion(BodyRegion.chest)],
        backRegions: [_fakeRegion(BodyRegion.upperBack)],
      );
      final vm = BodyMapViewModel(repo);
      await vm.init();

      await vm.toggleSide();
      await vm.toggleSide();

      expect(vm.side, BodySide.front);
      expect(vm.regions.first.region, BodyRegion.chest);
    });

    test('applyStress stores the region→level map and notifies listeners', () async {
      final repo = _FakeRepository(frontRegions: [], backRegions: []);
      final vm = BodyMapViewModel(repo);
      await vm.init();

      int notifyCount = 0;
      vm.addListener(() => notifyCount++);

      vm.applyStress({BodyRegion.chest: 8, BodyRegion.frontUpperArm: 3});

      expect(vm.stressByRegion[BodyRegion.chest], 8);
      expect(vm.stressByRegion[BodyRegion.frontUpperArm], 3);
      expect(notifyCount, 1);
    });

    test('applyStress is preserved across side toggle', () async {
      final repo = _FakeRepository(
        frontRegions: [_fakeRegion(BodyRegion.chest)],
        backRegions: [_fakeRegion(BodyRegion.upperBack)],
      );
      final vm = BodyMapViewModel(repo);
      await vm.init();

      vm.applyStress({BodyRegion.chest: 5});
      await vm.toggleSide();

      expect(vm.stressByRegion[BodyRegion.chest], 5);
    });

    test('hasError is true when repository throws', () async {
      final vm = BodyMapViewModel(_FailingRepository());

      await vm.init();

      expect(vm.hasError, isTrue);
      expect(vm.isLoading, isFalse);
      expect(vm.regions, isEmpty);
    });
  });
}

class _FailingRepository implements BodyMapRepository {
  @override
  Future<List<BodyRegionData>> getRegions({
    required BodySide side,
    required BodySex sex,
  }) async {
    throw Exception('SVG load failed');
  }

  @override
  Future<FigureOutlinePathData> getFigureOutline({
    required BodySide side,
    required BodySex sex,
  }) async {
    throw Exception('SVG load failed');
  }
}
