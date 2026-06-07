import 'package:powerflix/core/domain/models/workout_plan.dart';

abstract class WorkoutDatasource {
  Future<List<WorkoutPlan>> fetchWorkouts();
}
