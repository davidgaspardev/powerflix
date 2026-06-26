import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:moveflix/features/workout/domain/models/workout_cover.dart';
import 'package:moveflix/features/workout/domain/usecases/get_workout_cover_list_use_case.dart';
import 'package:moveflix/features/workout/domain/usecases/get_workout_plan_by_id.dart';
import 'package:moveflix/features/workout/domain/usecases/toggle_favorite_workout_use_case.dart';

class WorkoutListViewModel extends ChangeNotifier {
  final GetWorkoutCoverListUseCase _getWorkoutCoverListUseCase;
  final GetWorkoutPlanByIdUseCase _getWorkoutPlanByIdUseCase;
  final ToggleFavoriteWorkoutUseCase _toggleFavoriteWorkoutUseCase;
  final _navigationController = StreamController<String>.broadcast();

  Stream<String> get navigationEvents => _navigationController.stream;

  WorkoutListViewModel({
    required GetWorkoutCoverListUseCase getWorkoutCoverListUseCase,
    required GetWorkoutPlanByIdUseCase getWorkoutPlanByIdUseCase,
    required ToggleFavoriteWorkoutUseCase toggleFavoriteWorkoutUseCase,
  })  : _getWorkoutCoverListUseCase = getWorkoutCoverListUseCase,
        _getWorkoutPlanByIdUseCase = getWorkoutPlanByIdUseCase,
        _toggleFavoriteWorkoutUseCase = toggleFavoriteWorkoutUseCase;

  List<WorkoutCover> _workoutCoverList = [];

  List<WorkoutCover> get workoutCoverList => _workoutCoverList;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  String? _error;

  bool get hasError => _error != null;

  String? get error => _error;

  Future<void> loadWorkouts() async {
    _isLoading = true;
    notifyListeners();
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

  @override
  void dispose() {
    _navigationController.close();
    super.dispose();
  }

  Future<void> openWorkoutCover(String id) async {
    final workoutPlan = await _getWorkoutPlanByIdUseCase(id);
    _navigationController.add(workoutPlan.toJson());
  }

  Future<void> toggleFavorite(String workoutId) async {
    final index = _workoutCoverList.indexWhere((c) => c.id == workoutId);
    if (index == -1) return;

    final current = _workoutCoverList[index];
    _workoutCoverList = List.of(_workoutCoverList)
      ..[index] = current.copyWith(isFavorite: !current.isFavorite);
    notifyListeners();

    try {
      await _toggleFavoriteWorkoutUseCase(workoutId);
    } catch (_) {
      _workoutCoverList = List.of(_workoutCoverList)
        ..[index] = current;
      notifyListeners();
    }
  }
}
