import 'package:moveflix/features/workout/domain/models/workout_summary.dart';
import 'package:moveflix/features/workout/domain/repositories/workout_plan_repository.dart';
import 'package:moveflix/features/workout/domain/repositories/workout_preferences_repository.dart';

class BrowseWorkoutsUseCase {
  final WorkoutPlanRepository _workoutPlanRepository;
  final WorkoutPreferencesRepository _preferencesRepository;

  BrowseWorkoutsUseCase({
    required WorkoutPlanRepository workoutPlanRepository,
    required WorkoutPreferencesRepository preferencesRepository,
  })  : _workoutPlanRepository = workoutPlanRepository,
        _preferencesRepository = preferencesRepository;

  Future<List<WorkoutSummary>> call() async {
    final prefs = await _preferencesRepository.getPreferences();
    final workouts = await _workoutPlanRepository.getWorkouts();

    return workouts.map((workout) {
      final isFavorite = prefs.favoriteWorkoutIds.contains(workout.id);
      return WorkoutSummary.fromWorkoutPlan(workout, isFavorite: isFavorite);
    }).toList();
  }
}
