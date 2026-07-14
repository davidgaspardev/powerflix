import 'package:moveflix/features/workout/domain/repositories/workout_preferences_repository.dart';

class ToggleFavoriteWorkoutUseCase {
  final WorkoutPreferencesRepository _repository;

  ToggleFavoriteWorkoutUseCase(this._repository);

  Future<bool> call(String workoutId) async {
    final prefs = await _repository.getPreferences();
    final ids = List<String>.from(prefs.favoriteWorkoutIds);
    final isFavorite = ids.contains(workoutId);

    if (isFavorite) {
      ids.remove(workoutId);
    } else {
      ids.add(workoutId);
    }

    await _repository.savePreferences(prefs.copyWith(favoriteWorkoutIds: ids));
    return !isFavorite;
  }
}
