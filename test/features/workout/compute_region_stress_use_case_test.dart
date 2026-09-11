import 'package:flutter_test/flutter_test.dart';
import 'package:moveflix/core/domain/models/body_region.dart';
import 'package:moveflix/features/workout/domain/models/workout_plan.dart';
import 'package:moveflix/features/workout/domain/models/workout_preferences.dart';
import 'package:moveflix/features/workout/domain/repositories/workout_plan_repository.dart';
import 'package:moveflix/features/workout/domain/repositories/workout_preferences_repository.dart';
import 'package:moveflix/features/workout/domain/usecases/compute_region_stress_use_case.dart';

class _FakeWorkoutPlanRepository implements WorkoutPlanRepository {
  final List<WorkoutPlan> plans;

  _FakeWorkoutPlanRepository(this.plans);

  @override
  Future<WorkoutPlan> getById(String id) async =>
      plans.firstWhere((p) => p.id == id);

  @override
  Future<List<WorkoutPlan>> getWorkouts() async => plans;
}

class _FakeWorkoutPreferencesRepository implements WorkoutPreferencesRepository {
  final WorkoutPreferences prefs;

  _FakeWorkoutPreferencesRepository(this.prefs);

  @override
  Future<WorkoutPreferences> getPreferences() async => prefs;

  @override
  Future<void> savePreferences(WorkoutPreferences prefs) async {}
}

WorkoutPlan _plan(String id, List<BodyRegion> regions) => WorkoutPlan(
      id: id,
      name: id,
      description: '',
      coverUrl: '',
      primaryRegions: regions,
      levels: const [],
    );

void main() {
  group('ComputeRegionStressUseCase', () {
    test('returns empty map when nothing is favorited', () async {
      final useCase = ComputeRegionStressUseCase(
        workoutPlanRepository: _FakeWorkoutPlanRepository([
          _plan('chest', [BodyRegion.chest]),
        ]),
        preferencesRepository:
            _FakeWorkoutPreferencesRepository(const WorkoutPreferences()),
      );

      expect(await useCase(), isEmpty);
    });

    test('applies the fixed stress level to a favorited plan\'s muscles', () async {
      final useCase = ComputeRegionStressUseCase(
        workoutPlanRepository: _FakeWorkoutPlanRepository([
          _plan('chest', [BodyRegion.chest, BodyRegion.backUpperArm]),
        ]),
        preferencesRepository: _FakeWorkoutPreferencesRepository(
          const WorkoutPreferences(favoriteWorkoutIds: ['chest']),
        ),
      );

      final stress = await useCase();

      expect(stress[BodyRegion.chest], favoritedWorkoutStressLevel);
      expect(stress[BodyRegion.backUpperArm], favoritedWorkoutStressLevel);
    });

    test('ignores non-favorited plans', () async {
      final useCase = ComputeRegionStressUseCase(
        workoutPlanRepository: _FakeWorkoutPlanRepository([
          _plan('chest', [BodyRegion.chest]),
          _plan('legs', [BodyRegion.quads]),
        ]),
        preferencesRepository: _FakeWorkoutPreferencesRepository(
          const WorkoutPreferences(favoriteWorkoutIds: ['chest']),
        ),
      );

      final stress = await useCase();

      expect(stress.containsKey(BodyRegion.quads), isFalse);
    });

    test('overlapping favorited plans do not double-stack stress', () async {
      final useCase = ComputeRegionStressUseCase(
        workoutPlanRepository: _FakeWorkoutPlanRepository([
          _plan('legs_a', [BodyRegion.quads]),
          _plan('legs_b', [BodyRegion.quads]),
        ]),
        preferencesRepository: _FakeWorkoutPreferencesRepository(
          const WorkoutPreferences(favoriteWorkoutIds: ['legs_a', 'legs_b']),
        ),
      );

      final stress = await useCase();

      expect(stress[BodyRegion.quads], favoritedWorkoutStressLevel);
    });
  });
}
