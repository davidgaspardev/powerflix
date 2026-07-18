import 'package:flutter/foundation.dart';
import 'package:moveflix/features/workout/domain/models/workout_plan.dart';
import 'package:moveflix/features/workout/domain/usecases/get_workout_preferences_use_case.dart';
import 'package:moveflix/features/workout/domain/usecases/toggle_favorite_workout_use_case.dart';

class WorkoutDetailViewModel extends ChangeNotifier {
  final WorkoutPlan plan;
  final GetWorkoutPreferencesUseCase _getPreferences;
  final ToggleFavoriteWorkoutUseCase _toggleFavorite;

  final ValueNotifier<int> currentLevelNotifier = ValueNotifier(0);
  final ValueNotifier<bool> isFavoriteNotifier = ValueNotifier(false);

  WorkoutDetailViewModel({
    required this.plan,
    required GetWorkoutPreferencesUseCase getPreferences,
    required ToggleFavoriteWorkoutUseCase toggleFavorite,
  })  : _getPreferences = getPreferences,
        _toggleFavorite = toggleFavorite;

  Future<void> init() async {
    final prefs = await _getPreferences();
    isFavoriteNotifier.value = prefs.favoriteWorkoutIds.contains(plan.id);
  }

  Future<void> toggleFavorite() async {
    isFavoriteNotifier.value = await _toggleFavorite(plan.id);
  }

  void onLevelChanged(int index) => currentLevelNotifier.value = index;

  @override
  void dispose() {
    currentLevelNotifier.dispose();
    isFavoriteNotifier.dispose();
    super.dispose();
  }
}
