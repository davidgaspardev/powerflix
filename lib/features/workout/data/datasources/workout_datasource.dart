import 'package:moveflix/features/workout/domain/models/workout_plan.dart';

abstract class WorkoutDatasource {
  Future<List<WorkoutPlan>> fetchWorkouts();
}
