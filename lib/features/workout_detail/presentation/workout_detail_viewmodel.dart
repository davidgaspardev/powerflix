import 'package:flutter/foundation.dart';
import 'package:powerflix/core/domain/models/workout_plan.dart';

class WorkoutDetailViewModel extends ChangeNotifier {
  final WorkoutPlan plan;

  final ValueNotifier<int> currentLevelNotifier = ValueNotifier(0);
  final ValueNotifier<bool> isFavoriteNotifier = ValueNotifier(false);

  WorkoutDetailViewModel({required this.plan});

  void toggleFavorite() =>
      isFavoriteNotifier.value = !isFavoriteNotifier.value;

  void onLevelChanged(int index) => currentLevelNotifier.value = index;

  @override
  void dispose() {
    currentLevelNotifier.dispose();
    isFavoriteNotifier.dispose();
    super.dispose();
  }
}
