import 'package:powerflix/core/domain/models/workout_plan.dart';

class WorkoutCover {
  const WorkoutCover({
    required String name,
    required String description,
    required String coverUrl,
    bool isFavourite = false,
  });

  static WorkoutCover fromPlan(WorkoutPlan plan) {
    return WorkoutCover(
        name: plan.name,
        description: plan.description,
        coverUrl: plan.coverUrl
    );
  }
}