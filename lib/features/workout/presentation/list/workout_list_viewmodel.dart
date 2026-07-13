import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:moveflix/features/workout/domain/models/workout_summary.dart';
import 'package:moveflix/features/workout/domain/repositories/workout_plan_repository.dart';
import 'package:moveflix/features/workout/domain/usecases/browse_workouts_use_case.dart';
import 'package:moveflix/features/workout/domain/usecases/toggle_favorite_workout_use_case.dart';

class WorkoutListViewModel extends ChangeNotifier {
  final BrowseWorkoutsUseCase _browseWorkoutsUseCase;
  final WorkoutPlanRepository _workoutPlanRepository;
  final ToggleFavoriteWorkoutUseCase _toggleFavoriteWorkoutUseCase;
  final _navigationController = StreamController<String>.broadcast();

  Stream<String> get navigationEvents => _navigationController.stream;

  WorkoutListViewModel({
    required BrowseWorkoutsUseCase browseWorkoutsUseCase,
    required WorkoutPlanRepository workoutPlanRepository,
    required ToggleFavoriteWorkoutUseCase toggleFavoriteWorkoutUseCase,
  })  : _browseWorkoutsUseCase = browseWorkoutsUseCase,
        _workoutPlanRepository = workoutPlanRepository,
        _toggleFavoriteWorkoutUseCase = toggleFavoriteWorkoutUseCase;

  List<WorkoutSummary> _workoutSummaryList = [];

  List<WorkoutSummary> get workoutCoverList => _workoutSummaryList;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  String? _error;

  bool get hasError => _error != null;

  String? get error => _error;

  Future<void> loadWorkouts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _workoutSummaryList = await _browseWorkoutsUseCase();
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
    final workoutPlan = await _workoutPlanRepository.getById(id);
    _navigationController.add(workoutPlan.toJson());
  }

  Future<void> toggleFavorite(String workoutId) async {
    final index = _workoutSummaryList.indexWhere((c) => c.id == workoutId);
    if (index == -1) return;

    final current = _workoutSummaryList[index];
    _workoutSummaryList = List.of(_workoutSummaryList)
      ..[index] = current.copyWith(isFavorite: !current.isFavorite);
    notifyListeners();

    try {
      await _toggleFavoriteWorkoutUseCase(workoutId);
    } catch (_) {
      _workoutSummaryList = List.of(_workoutSummaryList)
        ..[index] = current;
      notifyListeners();
    }
  }
}
