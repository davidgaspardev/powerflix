import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:powerflix/core/domain/models/muscle_stress.dart';
import 'package:powerflix/core/domain/models/body_sex.dart';
import 'package:powerflix/features/muscle_map/domain/models/body_side.dart';
import 'package:powerflix/features/muscle_map/domain/models/figure_outline_path_data.dart';
import 'package:powerflix/features/muscle_map/domain/models/muscle_region_data.dart';
import 'package:powerflix/features/muscle_map/domain/repositories/body_map_repository.dart';
import 'package:powerflix/features/muscle_map/presentation/muscle_map_viewmodel.dart';

// ── fakes ──────────────────────────────────────────────────────────────────

class _FakeRepository implements BodyMapRepository {
  final List<MuscleRegionData> frontRegions;
  final List<MuscleRegionData> backRegions;
  int callCount = 0;

  _FakeRepository({required this.frontRegions, required this.backRegions});

  @override
  Future<List<MuscleRegionData>> getMuscleRegions({
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

MuscleRegionData _fakeRegion(String id) => MuscleRegionData(id: id, path: Path());

// ── tests ──────────────────────────────────────────────────────────────────

void main() {
  group('MuscleMapViewModel', () {
    test('init loads front regions and clears loading state', () async {
      final repo = _FakeRepository(
        frontRegions: [_fakeRegion('muscle_chest')],
        backRegions: [],
      );
      final vm = MuscleMapViewModel(repo);

      expect(vm.isLoading, isTrue);

      await vm.init();

      expect(vm.isLoading, isFalse);
      expect(vm.hasError, isFalse);
      expect(vm.regions, hasLength(1));
      expect(vm.regions.first.id, 'muscle_chest');
      expect(vm.side, BodySide.front);
    });

    test('toggleSide switches to back and reloads regions', () async {
      final repo = _FakeRepository(
        frontRegions: [_fakeRegion('muscle_chest')],
        backRegions: [_fakeRegion('muscle_trapezius'), _fakeRegion('muscle_lats')],
      );
      final vm = MuscleMapViewModel(repo);
      await vm.init();

      await vm.toggleSide();

      expect(vm.side, BodySide.back);
      expect(vm.regions, hasLength(2));
      expect(vm.regions.first.id, 'muscle_trapezius');
    });

    test('toggleSide twice returns to front regions', () async {
      final repo = _FakeRepository(
        frontRegions: [_fakeRegion('muscle_chest')],
        backRegions: [_fakeRegion('muscle_trapezius')],
      );
      final vm = MuscleMapViewModel(repo);
      await vm.init();

      await vm.toggleSide();
      await vm.toggleSide();

      expect(vm.side, BodySide.front);
      expect(vm.regions.first.id, 'muscle_chest');
    });

    test('onMuscleTap cycles stress: none → low → medium → high → none', () async {
      final repo = _FakeRepository(
        frontRegions: [_fakeRegion('muscle_chest')],
        backRegions: [],
      );
      final vm = MuscleMapViewModel(repo);
      await vm.init();

      expect(vm.stress['muscle_chest'], isNull);

      vm.onMuscleTap('muscle_chest');
      expect(vm.stress['muscle_chest'], MuscleStress.low);

      vm.onMuscleTap('muscle_chest');
      expect(vm.stress['muscle_chest'], MuscleStress.medium);

      vm.onMuscleTap('muscle_chest');
      expect(vm.stress['muscle_chest'], MuscleStress.high);

      vm.onMuscleTap('muscle_chest');
      expect(vm.stress['muscle_chest'], MuscleStress.none);
    });

    test('onMuscleTap on unknown id starts from none', () async {
      final repo = _FakeRepository(frontRegions: [], backRegions: []);
      final vm = MuscleMapViewModel(repo);
      await vm.init();

      vm.onMuscleTap('muscle_bicep');

      expect(vm.stress['muscle_bicep'], MuscleStress.low);
    });

    test('stress is preserved across side toggle', () async {
      final repo = _FakeRepository(
        frontRegions: [_fakeRegion('muscle_chest')],
        backRegions: [_fakeRegion('muscle_trapezius')],
      );
      final vm = MuscleMapViewModel(repo);
      await vm.init();

      vm.onMuscleTap('muscle_chest');
      expect(vm.stress['muscle_chest'], MuscleStress.low);

      await vm.toggleSide();

      expect(vm.stress['muscle_chest'], MuscleStress.low);
    });

    test('notifyListeners is called after onMuscleTap', () async {
      final repo = _FakeRepository(frontRegions: [], backRegions: []);
      final vm = MuscleMapViewModel(repo);
      await vm.init();

      int notifyCount = 0;
      vm.addListener(() => notifyCount++);

      vm.onMuscleTap('muscle_chest');

      expect(notifyCount, 1);
    });

    test('hasError is true when repository throws', () async {
      final vm = MuscleMapViewModel(_FailingRepository());

      await vm.init();

      expect(vm.hasError, isTrue);
      expect(vm.isLoading, isFalse);
      expect(vm.regions, isEmpty);
    });
  });
}

class _FailingRepository implements BodyMapRepository {
  @override
  Future<List<MuscleRegionData>> getMuscleRegions({
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
