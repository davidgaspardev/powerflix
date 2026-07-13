import 'package:moveflix/core/domain/repositories/user_repository.dart';
import 'package:moveflix/features/workout/domain/models/workout_summary.dart';
import 'package:moveflix/features/workout/domain/repositories/workout_plan_repository.dart';

class BrowseWorkoutsUseCase {
  final WorkoutPlanRepository _workoutPlanRepository;
  final UserRepository _userRepository;

  BrowseWorkoutsUseCase({
    required WorkoutPlanRepository workoutPlanRepository,
    required UserRepository userRepository,
  })  : _workoutPlanRepository = workoutPlanRepository,
        _userRepository = userRepository;

  Future<List<WorkoutSummary>> call() async {
    final preference = await _userRepository.getPreferences();
    final workoutPlanList = await _workoutPlanRepository.getWorkouts();
    return workoutPlanList.map((workout) {
      final isFavorite = preference.favoriteWorkoutIds.contains(workout.id);
      return WorkoutSummary.fromWorkoutPlan(workout, isFavorite: isFavorite);
    }).toList();
  }
}
