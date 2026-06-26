import 'package:flutter_test/flutter_test.dart';
import 'package:moveflix/core/domain/models/user.dart';
import 'package:moveflix/core/domain/models/user_preferences.dart';
import 'package:moveflix/core/domain/repositories/user_repository.dart';
import 'package:moveflix/features/workout/domain/models/workout_plan.dart';
import 'package:moveflix/features/workout/domain/repositories/workout_repository.dart';
import 'package:moveflix/features/workout/domain/usecases/get_workout_cover_list_use_case.dart';
import 'package:moveflix/features/workout/domain/usecases/get_workout_plan_by_id.dart';
import 'package:moveflix/features/workout/presentation/list/workout_list_viewmodel.dart';

class _FakeWorkoutRepository implements WorkoutRepository {
  final List<WorkoutPlan> plans;
  final Object? error;

  _FakeWorkoutRepository({this.plans = const [], this.error});

  @override
  Future<List<WorkoutPlan>> getWorkouts() async {
    if (error != null) throw error!;
    return plans;
  }

  @override
  Future<WorkoutPlan> getById(String id) async =>
      plans.firstWhere((p) => p.id == id);
}

class _FakeUserRepository implements UserRepository {
  @override
  Future<UserModel?> getUser() async => null;
  @override
  Future<void> saveUser(UserModel user) async {}
  @override
  Future<UserPreferences> getPreferences() async => const UserPreferences();
  @override
  Future<void> savePreferences(UserPreferences prefs) async {}
}

WorkoutPlan _plan(String id, String name) => WorkoutPlan(
      id: id,
      name: name,
      description: 'desc',
      coverUrl: 'https://example.com/$id.jpg',
      levels: const [],
    );

WorkoutListViewModel _vm({List<WorkoutPlan> plans = const [], Object? error}) {
  final workoutRepo = _FakeWorkoutRepository(plans: plans, error: error);
  final userRepo = _FakeUserRepository();
  return WorkoutListViewModel(
    getWorkoutCoverListUseCase: GetWorkoutCoverListUseCase(
      workoutPlanRepository: workoutRepo,
      userRepository: userRepo,
    ),
    getWorkoutPlanByIdUseCase: GetWorkoutPlanByIdUseCase(
      workoutPlanRepository: workoutRepo,
    ),
  );
}

void main() {
  group('WorkoutListViewModel', () {
    test('initial state: isLoading=true, empty list, no error', () {
      final vm = _vm(plans: [_plan('p1', 'Leg Day')]);
      expect(vm.isLoading, isTrue);
      expect(vm.workoutCoverList, isEmpty);
      expect(vm.hasError, isFalse);
      expect(vm.error, isNull);
    });

    test('loadWorkouts success: populates cover list, clears error, isLoading=false', () async {
      final vm = _vm(plans: [_plan('plan-1', 'Leg Day')]);
      await vm.loadWorkouts();

      expect(vm.isLoading, isFalse);
      expect(vm.hasError, isFalse);
      expect(vm.workoutCoverList, hasLength(1));
      expect(vm.workoutCoverList.first.id, 'plan-1');
    });

    test('loadWorkouts parses multiple plans correctly', () async {
      final vm = _vm(plans: [_plan('plan-1', 'Leg Day'), _plan('plan-2', 'Arm Day')]);
      await vm.loadWorkouts();

      expect(vm.workoutCoverList, hasLength(2));
      expect(vm.workoutCoverList[0].id, 'plan-1');
      expect(vm.workoutCoverList[1].id, 'plan-2');
    });

    test('loadWorkouts error: sets error, list remains empty, isLoading=false', () async {
      final vm = _vm(error: Exception('asset not found'));
      await vm.loadWorkouts();

      expect(vm.isLoading, isFalse);
      expect(vm.hasError, isTrue);
      expect(vm.error, contains('asset not found'));
      expect(vm.workoutCoverList, isEmpty);
    });

    test('loadWorkouts notifies listeners on success', () async {
      final vm = _vm(plans: [_plan('p1', 'A')]);
      var notifyCount = 0;
      vm.addListener(() => notifyCount++);
      await vm.loadWorkouts();
      expect(notifyCount, 1);
    });

    test('loadWorkouts notifies listeners on error', () async {
      final vm = _vm(error: Exception('fail'));
      var notifyCount = 0;
      vm.addListener(() => notifyCount++);
      await vm.loadWorkouts();
      expect(notifyCount, 1);
    });

    test('init() triggers loadWorkouts asynchronously', () async {
      final vm = _vm(plans: [_plan('p1', 'A')]);
      vm.init();
      expect(vm.isLoading, isTrue);
      await Future.delayed(Duration.zero);
      expect(vm.isLoading, isFalse);
      expect(vm.workoutCoverList, hasLength(1));
    });
  });
}
