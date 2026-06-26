import 'package:moveflix/core/domain/repositories/user_repository.dart';
import 'package:moveflix/features/workout/domain/models/workout_cover.dart';
import 'package:moveflix/features/workout/domain/repositories/workout_repository.dart';

class GetWorkoutCoverListUseCase {
  late final WorkoutRepository workoutPlanRepository;
  late final UserRepository userRepository;

  GetWorkoutCoverListUseCase({
    required this.workoutPlanRepository,
    required this.userRepository,
  });

  Future<List<WorkoutCover>> call() async {
    final preference = await userRepository.getPreferences();
    final workoutPlanList = await workoutPlanRepository.getWorkouts();
    final workoutCoverList = workoutPlanList.map((workout) {
      final isFavorite = preference.favoriteWorkoutIds.contains(workout.id);
      return WorkoutCover.fromWorkoutPlan(workout, isFavorite: isFavorite);
    }).toList();

    return workoutCoverList;
  }
}
