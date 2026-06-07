import 'package:powerflix/core/domain/models/workout_plan.dart';
import 'package:powerflix/features/home/data/datasources/workout_datasource.dart';
import 'package:powerflix/features/home/domain/repositories/workout_repository.dart';

class WorkoutRepositoryImpl implements WorkoutRepository {
  final WorkoutDatasource _datasource;

  WorkoutRepositoryImpl(this._datasource);

  @override
  Future<List<WorkoutPlan>> getWorkouts() => _datasource.fetchWorkouts();
}
