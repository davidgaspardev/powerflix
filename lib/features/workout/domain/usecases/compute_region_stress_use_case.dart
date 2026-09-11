import 'package:moveflix/core/domain/models/body_region.dart';
import 'package:moveflix/features/workout/domain/repositories/workout_plan_repository.dart';
import 'package:moveflix/features/workout/domain/repositories/workout_preferences_repository.dart';

/// Stress level (1-10 scale) contributed by each favorited `WorkoutPlan` to
/// the body regions it targets. There is no execution history to derive a
/// real intensity from yet, so every favorited plan contributes the same
/// fixed level.
const favoritedWorkoutStressLevel = 7;

/// Derives a per-[BodyRegion] stress map from the user's favorited workout
/// plans, for `body_map` to render via `BodyMapViewModel.applyStress`.
class ComputeRegionStressUseCase {
  final WorkoutPlanRepository _workoutPlanRepository;
  final WorkoutPreferencesRepository _preferencesRepository;

  ComputeRegionStressUseCase({
    required WorkoutPlanRepository workoutPlanRepository,
    required WorkoutPreferencesRepository preferencesRepository,
  })  : _workoutPlanRepository = workoutPlanRepository,
        _preferencesRepository = preferencesRepository;

  Future<Map<BodyRegion, int>> call() async {
    final prefs = await _preferencesRepository.getPreferences();
    final workouts = await _workoutPlanRepository.getWorkouts();

    final stressByRegion = <BodyRegion, int>{};
    for (final workout in workouts) {
      if (!prefs.favoriteWorkoutIds.contains(workout.id)) continue;

      for (final region in workout.primaryRegions) {
        final current = stressByRegion[region] ?? 0;
        if (favoritedWorkoutStressLevel > current) {
          stressByRegion[region] = favoritedWorkoutStressLevel;
        }
      }
    }
    return stressByRegion;
  }
}
