import 'package:powerflix/core/domain/models/workout_plan.dart';

abstract class WorkoutRepository {
  Future<List<WorkoutPlan>> getWorkouts();
}
