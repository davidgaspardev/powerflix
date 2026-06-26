import 'package:moveflix/features/workout/domain/models/workout_plan.dart';
import 'package:moveflix/features/workout/data/datasources/workout_cache_datasource.dart';
import 'package:moveflix/features/workout/data/datasources/workout_datasource.dart';
import 'package:moveflix/features/workout/domain/repositories/workout_repository.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutDatasource _source;
  final WorkoutCacheDatasource _cache;

  WorkoutRepositoryImpl(this._source, this._cache);

  @override
  Future<WorkoutPlan> getById(String id) async {
    final workout = await getWorkouts();

    return workout.firstWhere((workout) => workout.id == id);
  }

  @override
  Future<List<WorkoutPlan>> getWorkouts() async {
    final cached = await _cache.getCached();
    if (cached.isNotEmpty) return cached;
    final plans = await _source.fetchWorkouts();
    await _cache.cache(plans);
    return plans;
  }
}
