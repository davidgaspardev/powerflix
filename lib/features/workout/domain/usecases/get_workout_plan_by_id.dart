import 'package:moveflix/features/workout/domain/models/workout_plan.dart';
import 'package:moveflix/features/workout/domain/repositories/workout_repository.dart';

class GetWorkoutPlanByIdUseCase {
  late final WorkoutRepository _workoutPlanRepository;

  GetWorkoutPlanByIdUseCase({
    required WorkoutRepository workoutPlanRepository,
  }) : _workoutPlanRepository = workoutPlanRepository;

  Future<WorkoutPlan> call(String id) async {
    return _workoutPlanRepository.getById(id);
  }
}