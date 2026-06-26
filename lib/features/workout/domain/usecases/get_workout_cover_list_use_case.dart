import 'package:moveflix/core/domain/repositories/user_repository.dart';
import 'package:moveflix/features/workout/domain/models/workout_cover.dart';
import 'package:moveflix/features/workout/domain/repositories/workout_repository.dart';

class GetWorkoutCoverListUseCase {
  final WorkoutRepository _workoutPlanRepository;
  final UserRepository _userRepository;

  GetWorkoutCoverListUseCase({
    required WorkoutRepository workoutPlanRepository,
    required UserRepository userRepository,
  })  : _workoutPlanRepository = workoutPlanRepository,
        _userRepository = userRepository;

  Future<List<WorkoutCover>> call() async {
    final preference = await _userRepository.getPreferences();
    final workoutPlanList = await _workoutPlanRepository.getWorkouts();
    final workoutCoverList = workoutPlanList.map((workout) {
      final isFavorite = preference.favoriteWorkoutIds.contains(workout.id);
      return WorkoutCover.fromWorkoutPlan(workout, isFavorite: isFavorite);
    }).toList();

    return workoutCoverList;
  }
}
