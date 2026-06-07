import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:powerflix/core/domain/models/workout_plan.dart';

class HomeViewModel extends ChangeNotifier {
  static const _workoutsAsset = 'lib/app/assets/data/workouts.json';

  HomeViewModel({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  List<WorkoutPlan> _workouts = [];
  List<WorkoutPlan> get workouts => _workouts;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  bool get hasError => _error != null;
  String? get error => _error;

  void init() {
    loadWorkouts();
  }

  Future<void> loadWorkouts() async {
    try {
      final raw = await _bundle.loadString(_workoutsAsset);
      final list = jsonDecode(raw) as List;
      _workouts = list
          .map<WorkoutPlan>((e) => WorkoutPlan.fromMap(Map<String, dynamic>.from(e)))
          .toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
