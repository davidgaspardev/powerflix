import 'dart:convert';

import 'package:moveflix/core/domain/model.dart';

class UserPreferences extends Model {
  final List<String> favoriteWorkoutIds;

  const UserPreferences({this.favoriteWorkoutIds = const []});

  UserPreferences copyWith({List<String>? favoriteWorkoutIds}) =>
      UserPreferences(
        favoriteWorkoutIds: favoriteWorkoutIds ?? this.favoriteWorkoutIds,
      );

  static UserPreferences fromMap(Map<String, dynamic> map) {
    return UserPreferences(
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
