import 'package:flutter/foundation.dart';
import 'package:powerflix/core/domain/models/workout_plan.dart';
import 'package:powerflix/core/domain/repositories/favorites_repository.dart';

class WorkoutDetailViewModel extends ChangeNotifier {
  final WorkoutPlan plan;
  final FavoritesRepository _repository;

  final ValueNotifier<int> currentLevelNotifier = ValueNotifier(0);
  final ValueNotifier<bool> isFavoriteNotifier = ValueNotifier(false);

  WorkoutDetailViewModel({
    required this.plan,
    required FavoritesRepository repository,
  }) : _repository = repository;

  Future<void> init() async {
    isFavoriteNotifier.value = await _repository.isFavorite(plan.id);
  }

  Future<void> toggleFavorite() async {
    final newValue = !isFavoriteNotifier.value;
    isFavoriteNotifier.value = newValue;
    await _repository.setFavorite(plan.id, newValue);
  }

  void onLevelChanged(int index) => currentLevelNotifier.value = index;

  @override
  void dispose() {
    currentLevelNotifier.dispose();
    isFavoriteNotifier.dispose();
    super.dispose();
  }
}
