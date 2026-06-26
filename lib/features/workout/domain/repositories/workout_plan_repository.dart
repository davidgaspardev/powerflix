import 'package:moveflix/features/workout/domain/models/workout_plan.dart';

abstract class WorkoutPlanRepository {
  Future<WorkoutPlan> getById(String id);
  Future<List<WorkoutPlan>> getWorkouts();
}
