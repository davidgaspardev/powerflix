import 'dart:convert';

import 'package:moveflix/core/domain/model.dart';

class WorkoutPreferences extends Model {
  final List<String> favoriteWorkoutIds;

  const WorkoutPreferences({this.favoriteWorkoutIds = const []});

  WorkoutPreferences copyWith({List<String>? favoriteWorkoutIds}) =>
      WorkoutPreferences(
        favoriteWorkoutIds: favoriteWorkoutIds ?? this.favoriteWorkoutIds,
      );

  static WorkoutPreferences fromMap(Map<String, dynamic> map) {
    return WorkoutPreferences(
      favoriteWorkoutIds:
          List<String>.from(map['favoriteWorkoutIds'] as List? ?? []),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'favoriteWorkoutIds': favoriteWorkoutIds,
      };

  @override
  String toJson() => jsonEncode(toMap());
}
