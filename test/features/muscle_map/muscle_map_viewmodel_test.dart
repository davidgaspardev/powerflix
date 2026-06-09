import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:powerflix/core/domain/models/muscle_stress.dart';
import 'package:powerflix/features/muscle_map/domain/models/muscle_path_data.dart';
import 'package:powerflix/features/muscle_map/domain/repositories/muscle_map_repository.dart';
import 'package:powerflix/features/muscle_map/presentation/muscle_map_viewmodel.dart';

// ── fakes ──────────────────────────────────────────────────────────────────

class _FakeRepository implements MuscleMapRepository {
  final List<MusclePathData> frontPaths;
  final List<MusclePathData> backPaths;
  int callCount = 0;

  _FakeRepository({required this.frontPaths, required this.backPaths});

  @override
  Future<List<MusclePathData>> getPaths({required bool isFront}) async {
    callCount++;
    return isFront ? frontPaths : backPaths;
  }
}

MusclePathData _fakePath(String id) =>
    MusclePathData(id: id, path: Path());

// ── tests ──────────────────────────────────────────────────────────────────

void main() {
  group('MuscleMapViewModel', () {
    test('init loads front paths and clears loading state', () async {
      final repo = _FakeRepository(
        frontPaths: [_fakePath('muscle_chest')],
        backPaths: [],
      );
      final vm = MuscleMapViewModel(repo);

      expect(vm.isLoading, isTrue);

      await vm.init();

      expect(vm.isLoading, isFalse);
      expect(vm.hasError, isFalse);
      expect(vm.paths, hasLength(1));
      expect(vm.paths.first.id, 'muscle_chest');
      expect(vm.isFront, isTrue);
    });

    test('toggleSide switches to back and reloads paths', () async {
      final repo = _FakeRepository(
        frontPaths: [_fakePath('muscle_chest')],
        backPaths: [_fakePath('muscle_trapezius'), _fakePath('muscle_lats')],
      );
      final vm = MuscleMapViewModel(repo);
      await vm.init();

      await vm.toggleSide();

      expect(vm.isFront, isFalse);
      expect(vm.paths, hasLength(2));
      expect(vm.paths.first.id, 'muscle_trapezius');
    });

    test('toggleSide twice returns to front paths', () async {
      final repo = _FakeRepository(
        frontPaths: [_fakePath('muscle_chest')],
        backPaths: [_fakePath('muscle_trapezius')],
      );
      final vm = MuscleMapViewModel(repo);
      await vm.init();

      await vm.toggleSide();
      await vm.toggleSide();

      expect(vm.isFront, isTrue);
      expect(vm.paths.first.id, 'muscle_chest');
    });

    test('onMuscleTap cycles stress: none → low → medium → high → none', () async {
      final repo = _FakeRepository(
        frontPaths: [_fakePath('muscle_chest')],
        backPaths: [],
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
      final repo = _FakeRepository(frontPaths: [], backPaths: []);
      final vm = MuscleMapViewModel(repo);
      await vm.init();

      vm.onMuscleTap('muscle_bicep');

      expect(vm.stress['muscle_bicep'], MuscleStress.low);
    });

    test('stress is preserved across side toggle', () async {
      final repo = _FakeRepository(
        frontPaths: [_fakePath('muscle_chest')],
        backPaths: [_fakePath('muscle_trapezius')],
      );
      final vm = MuscleMapViewModel(repo);
      await vm.init();

      vm.onMuscleTap('muscle_chest');
      expect(vm.stress['muscle_chest'], MuscleStress.low);

      await vm.toggleSide();

      expect(vm.stress['muscle_chest'], MuscleStress.low);
    });

    test('notifyListeners is called after onMuscleTap', () async {
      final repo = _FakeRepository(frontPaths: [], backPaths: []);
      final vm = MuscleMapViewModel(repo);
      await vm.init();

      int notifyCount = 0;
      vm.addListener(() => notifyCount++);

      vm.onMuscleTap('muscle_chest');

      expect(notifyCount, 1);
    });

    test('hasError is true when repository throws', () async {
      final repo = _FailingRepository();
      final vm = MuscleMapViewModel(repo);

      await vm.init();

      expect(vm.hasError, isTrue);
      expect(vm.isLoading, isFalse);
      expect(vm.paths, isEmpty);
    });
  });
}

class _FailingRepository implements MuscleMapRepository {
  @override
  Future<List<MusclePathData>> getPaths({required bool isFront}) async {
    throw Exception('SVG load failed');
  }
}
