import 'package:moveflix/features/workout/domain/models/workout_preferences.dart';

abstract class WorkoutPreferencesRepository {
  Future<WorkoutPreferences> getPreferences();
  Future<void> savePreferences(WorkoutPreferences prefs);
}
