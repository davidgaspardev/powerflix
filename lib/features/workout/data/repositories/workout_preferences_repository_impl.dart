import 'package:moveflix/features/workout/data/datasources/workout_preferences_datasource.dart';
import 'package:moveflix/features/workout/domain/models/workout_preferences.dart';
import 'package:moveflix/features/workout/domain/repositories/workout_preferences_repository.dart';

class WorkoutPreferencesRepositoryImpl implements WorkoutPreferencesRepository {
  final WorkoutPreferencesDatasource _datasource;

  WorkoutPreferencesRepositoryImpl(this._datasource);

  @override
  Future<WorkoutPreferences> getPreferences() => _datasource.getPreferences();

  @override
  Future<void> savePreferences(WorkoutPreferences prefs) =>
      _datasource.savePreferences(prefs);
}
