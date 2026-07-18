import 'package:moveflix/features/workout/domain/models/workout_preferences.dart';
import 'package:moveflix/features/workout/domain/repositories/workout_preferences_repository.dart';

class GetWorkoutPreferencesUseCase {
  final WorkoutPreferencesRepository _repository;

  GetWorkoutPreferencesUseCase(this._repository);

  Future<WorkoutPreferences> call() => _repository.getPreferences();
}
