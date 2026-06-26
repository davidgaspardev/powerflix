import 'package:flutter/foundation.dart';
import 'package:moveflix/features/workout/domain/models/workout_plan.dart';
import 'package:moveflix/core/domain/repositories/user_repository.dart';

class WorkoutDetailViewModel extends ChangeNotifier {
  final WorkoutPlan plan;
  final UserRepository _repository;

  final ValueNotifier<int> currentLevelNotifier = ValueNotifier(0);
  final ValueNotifier<bool> isFavoriteNotifier = ValueNotifier(false);

  WorkoutDetailViewModel({
    required this.plan,
    required UserRepository repository,
  }) : _repository = repository;

  Future<void> init() async {
    final prefs = await _repository.getPreferences();
    isFavoriteNotifier.value = prefs.favoriteWorkoutIds.contains(plan.id);
  }

  Future<void> toggleFavorite() async {
    final prefs = await _repository.getPreferences();
    final ids = List<String>.from(prefs.favoriteWorkoutIds);
    if (ids.contains(plan.id)) {
      ids.remove(plan.id);
    } else {
      ids.add(plan.id);
    }
    await _repository.savePreferences(prefs.copyWith(favoriteWorkoutIds: ids));
    isFavoriteNotifier.value = ids.contains(plan.id);
  }

  void onLevelChanged(int index) => currentLevelNotifier.value = index;

  @override
  void dispose() {
    currentLevelNotifier.dispose();
    isFavoriteNotifier.dispose();
    super.dispose();
  }
}
