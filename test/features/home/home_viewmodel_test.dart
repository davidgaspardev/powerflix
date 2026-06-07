import 'package:flutter_test/flutter_test.dart';
import 'package:powerflix/core/domain/models/workout_plan.dart';
import 'package:powerflix/features/home/domain/repositories/workout_repository.dart';
import 'package:powerflix/features/home/presentation/home_viewmodel.dart';

class _FakeWorkoutRepository implements WorkoutRepository {
  final List<WorkoutPlan> plans;
  final Object? error;

  _FakeWorkoutRepository({this.plans = const [], this.error});

  @override
  Future<List<WorkoutPlan>> getWorkouts() async {
    if (error != null) throw error!;
    return plans;
  }
}

WorkoutPlan _plan(String id, String name) => WorkoutPlan(
      id: id,
      name: name,
      description: 'desc',
      coverUrl: 'https://example.com/$id.jpg',
      levels: const [],
    );

void main() {
  group('HomeViewModel', () {
    test('initial state: isLoading=true, empty workouts, no error', () {
      final vm = HomeViewModel(_FakeWorkoutRepository(plans: [_plan('p1', 'Leg Day')]));
      expect(vm.isLoading, isTrue);
      expect(vm.workouts, isEmpty);
      expect(vm.hasError, isFalse);
      expect(vm.error, isNull);
    });

    test('loadWorkouts success: populates workouts, clears error, isLoading=false', () async {
      final vm = HomeViewModel(_FakeWorkoutRepository(plans: [_plan('plan-1', 'Leg Day')]));
      await vm.loadWorkouts();

      expect(vm.isLoading, isFalse);
      expect(vm.hasError, isFalse);
      expect(vm.workouts, hasLength(1));
      expect(vm.workouts.first.id, 'plan-1');
      expect(vm.workouts.first.name, 'Leg Day');
    });

    test('loadWorkouts parses multiple plans correctly', () async {
      final vm = HomeViewModel(_FakeWorkoutRepository(
        plans: [_plan('plan-1', 'Leg Day'), _plan('plan-2', 'Arm Day')],
      ));
      await vm.loadWorkouts();

      expect(vm.workouts, hasLength(2));
      expect(vm.workouts[0].id, 'plan-1');
      expect(vm.workouts[1].id, 'plan-2');
    });

    test('loadWorkouts error: sets error, workouts remain empty, isLoading=false', () async {
      final vm = HomeViewModel(_FakeWorkoutRepository(error: Exception('asset not found')));
      await vm.loadWorkouts();

      expect(vm.isLoading, isFalse);
      expect(vm.hasError, isTrue);
      expect(vm.error, contains('asset not found'));
      expect(vm.workouts, isEmpty);
    });

    test('loadWorkouts notifies listeners on success', () async {
      final vm = HomeViewModel(_FakeWorkoutRepository(plans: [_plan('p1', 'A')]));
      var notifyCount = 0;
      vm.addListener(() => notifyCount++);
      await vm.loadWorkouts();
      expect(notifyCount, 1);
    });

    test('loadWorkouts notifies listeners on error', () async {
      final vm = HomeViewModel(_FakeWorkoutRepository(error: Exception('fail')));
      var notifyCount = 0;
      vm.addListener(() => notifyCount++);
      await vm.loadWorkouts();
      expect(notifyCount, 1);
    });

    test('init() triggers loadWorkouts asynchronously', () async {
      final vm = HomeViewModel(_FakeWorkoutRepository(plans: [_plan('p1', 'A')]));
      vm.init();
      expect(vm.isLoading, isTrue);
      await Future.delayed(Duration.zero);
      expect(vm.isLoading, isFalse);
      expect(vm.workouts, hasLength(1));
    });
  });
}
