import 'package:moveflix/core/domain/models/muscle_group.dart';
import 'package:moveflix/features/workout/domain/repositories/workout_plan_repository.dart';
import 'package:moveflix/features/workout/domain/repositories/workout_preferences_repository.dart';

/// Stress level (1-10 scale) contributed by each favorited [WorkoutPlan] to
/// the muscle groups it targets. There is no execution history to derive a
/// real intensity from yet, so every favorited plan contributes the same
/// fixed level.
const favoritedWorkoutStressLevel = 7;

/// Derives a per-[MuscleGroup] stress map from the user's favorited workout
/// plans, for `body_map` to render via `BodyMapViewModel.applyStress`.
class ComputeMuscleStressUseCase {
  final WorkoutPlanRepository _workoutPlanRepository;
  final WorkoutPreferencesRepository _preferencesRepository;

  ComputeMuscleStressUseCase({
    required WorkoutPlanRepository workoutPlanRepository,
    required WorkoutPreferencesRepository preferencesRepository,
  })  : _workoutPlanRepository = workoutPlanRepository,
        _preferencesRepository = preferencesRepository;

  Future<Map<MuscleGroup, int>> call() async {
    final prefs = await _preferencesRepository.getPreferences();
    final workouts = await _workoutPlanRepository.getWorkouts();

    final stressByGroup = <MuscleGroup, int>{};
    for (final workout in workouts) {
      if (!prefs.favoriteWorkoutIds.contains(workout.id)) continue;

      for (final muscle in workout.primaryMuscles) {
        final current = stressByGroup[muscle] ?? 0;
        if (favoritedWorkoutStressLevel > current) {
          stressByGroup[muscle] = favoritedWorkoutStressLevel;
        }
      }
    }
    return stressByGroup;
  }
}
