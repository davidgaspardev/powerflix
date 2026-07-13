import 'dart:convert';

import 'package:moveflix/core/domain/model.dart';
import 'package:moveflix/features/workout/domain/models/workout_plan.dart';

class WorkoutSummary extends Model {
  final String id;
  final String description;
  final String coverUrl;
  final bool isFavorite;

  const WorkoutSummary({
    required this.id,
    required this.description,
    required this.coverUrl,
    required this.isFavorite,
  });

  WorkoutSummary copyWith({bool? isFavorite}) => WorkoutSummary(
        id: id,
        description: description,
        coverUrl: coverUrl,
        isFavorite: isFavorite ?? this.isFavorite,
      );

  static WorkoutSummary fromWorkoutPlan(
    WorkoutPlan workoutPlan, {
    bool isFavorite = false,
  }) {
    return WorkoutSummary(
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
      'isFavorite': isFavorite,
    };
  }

  @override
  String toJson() => jsonEncode(toMap());
}
