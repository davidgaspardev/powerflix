import 'dart:convert';

import 'package:moveflix/core/domain/model.dart';
import 'package:moveflix/features/workout/domain/models/workout_plan.dart';

class WorkoutCover extends Model {
  final String id;
  final String description;
  final String coverUrl;
  final bool isFavorite;

  const WorkoutCover({
    required this.id,
    required this.description,
    required this.coverUrl,
    required this.isFavorite,
  });

  static WorkoutCover fromWorkoutPlan(
    WorkoutPlan workoutPlan, {
    bool isFavorite = false,
  }) {
    return WorkoutCover(
      id: workoutPlan.id,
      description: workoutPlan.description,
      coverUrl: workoutPlan.coverUrl,
      isFavorite: isFavorite,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'coverUrl': coverUrl,
      'isFavorite': isFavorite
    };
  }

  @override
  String toJson() => jsonEncode(toMap());
}
