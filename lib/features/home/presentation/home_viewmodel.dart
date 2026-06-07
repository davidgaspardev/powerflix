import 'package:flutter/foundation.dart';
import 'package:powerflix/core/domain/models/workout_plan.dart';
import 'package:powerflix/features/home/domain/repositories/workout_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final WorkoutRepository _repository;

  HomeViewModel(this._repository);

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
      _workouts = await _repository.getWorkouts();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
