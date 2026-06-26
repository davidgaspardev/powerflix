import 'package:moveflix/features/workout/domain/models/workout_plan.dart';
import 'package:moveflix/features/workout/domain/repositories/workout_plan_repository.dart';

class GetWorkoutPlanByIdUseCase {
  late final WorkoutPlanRepository _workoutPlanRepository;

  GetWorkoutPlanByIdUseCase({
    required WorkoutPlanRepository workoutPlanRepository,
  }) : _workoutPlanRepository = workoutPlanRepository;

  Future<WorkoutPlan> call(String id) async {
    return _workoutPlanRepository.getById(id);
  }
}