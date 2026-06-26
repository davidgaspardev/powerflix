import 'package:moveflix/features/workout/domain/models/workout_plan.dart';

abstract class WorkoutRepository {
  Future<WorkoutPlan> getById(String id);
  Future<List<WorkoutPlan>> getWorkouts();
}
