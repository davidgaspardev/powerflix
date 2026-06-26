import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:moveflix/features/workout/domain/models/workout_cover.dart';
import 'package:moveflix/features/workout/domain/usecases/get_workout_cover_list_use_case.dart';
import 'package:moveflix/features/workout/domain/usecases/get_workout_plan_by_id.dart';

class WorkoutListViewModel extends ChangeNotifier {
  final GetWorkoutCoverListUseCase _getWorkoutCoverListUseCase;
  final GetWorkoutPlanByIdUseCase _getWorkoutPlanByIdUseCase;
  final _navigationController = StreamController<String>.broadcast();

  Stream<String> get navigationEvents => _navigationController.stream;

  WorkoutListViewModel({
    required GetWorkoutCoverListUseCase getWorkoutCoverListUseCase,
    required GetWorkoutPlanByIdUseCase getWorkoutPlanByIdUseCase,
  })  : _getWorkoutCoverListUseCase = getWorkoutCoverListUseCase,
        _getWorkoutPlanByIdUseCase = getWorkoutPlanByIdUseCase;

  List<WorkoutCover> _workoutCoverList = [];

  List<WorkoutCover> get workoutCoverList => _workoutCoverList;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  String? _error;

  bool get hasError => _error != null;

  String? get error => _error;

  Future<void> loadWorkouts() async {
    try {
      _workoutCoverList = await _getWorkoutCoverListUseCase();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> openWorkoutCover(String id) async {
    final workoutPlan = await _getWorkoutPlanByIdUseCase(id);
    _navigationController.add(workoutPlan.toJson());
  }
}
