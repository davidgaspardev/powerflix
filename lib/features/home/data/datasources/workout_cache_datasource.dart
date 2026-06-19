import 'package:moveflix/core/domain/models/workout_plan.dart';

abstract class WorkoutCacheDatasource {
  Future<List<WorkoutPlan>> getCached();
  Future<void> cache(List<WorkoutPlan> plans);
  Future<void> clearCache();
}
