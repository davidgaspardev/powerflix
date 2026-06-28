import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:moveflix/features/workout/domain/models/workout_plan.dart';
import 'package:moveflix/features/workout/data/datasources/workout_datasource.dart';

class WorkoutLocalDatasource implements WorkoutDatasource {
  static const _assetPath = 'assets/data/workouts.json';

  final AssetBundle _bundle;

  WorkoutLocalDatasource({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  @override
  Future<List<WorkoutPlan>> fetchWorkouts() async {
    final raw = await _bundle.loadString(_assetPath);
    final list = jsonDecode(raw) as List;
    return list
        .map<WorkoutPlan>((e) => WorkoutPlan.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }
}
