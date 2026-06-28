import 'package:hive/hive.dart';
import 'package:moveflix/features/workout/domain/models/workout_plan.dart';
import 'package:moveflix/features/workout/data/datasources/workout_cache_datasource.dart';

class WorkoutHiveDatasource implements WorkoutCacheDatasource {
  static const _boxName = 'workout_plans';

  @override
  Future<List<WorkoutPlan>> getCached() async {
    final box = await Hive.openBox<WorkoutPlan>(_boxName);
    return box.values.toList();
  }

  @override
  Future<void> cache(List<WorkoutPlan> plans) async {
    final box = await Hive.openBox<WorkoutPlan>(_boxName);
    await box.clear();
    await box.addAll(plans);
  }

  @override
  Future<void> clearCache() async {
    final box = await Hive.openBox<WorkoutPlan>(_boxName);
    await box.clear();
  }
}
