import 'package:moveflix/features/workout/domain/models/workout_plan.dart';

abstract class WorkoutCacheDatasource {
  Future<List<WorkoutPlan>> getCached();
  Future<void> cache(List<WorkoutPlan> plans);
  Future<void> clearCache();
}
