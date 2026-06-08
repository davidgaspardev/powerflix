import 'package:flutter/foundation.dart';
import 'package:powerflix/core/domain/models/muscle_stress.dart';
import 'package:powerflix/features/muscle_map/domain/models/muscle_path_data.dart';
import 'package:powerflix/features/muscle_map/domain/repositories/muscle_map_repository.dart';

class MuscleMapViewModel extends ChangeNotifier {
  final MuscleMapRepository _repository;

  MuscleMapViewModel(this._repository);

  List<MusclePathData> _paths = [];
  List<MusclePathData> get paths => _paths;

  final Map<String, MuscleStress> _stress = {};
  Map<String, MuscleStress> get stress => Map.unmodifiable(_stress);

  bool _isFront = true;
  bool get isFront => _isFront;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  bool get hasError => _error != null;

  Future<void> init() => _loadPaths();

  Future<void> toggleSide() async {
    _isFront = !_isFront;
    await _loadPaths();
  }

  void onMuscleTap(String muscleId) {
    final current = _stress[muscleId] ?? MuscleStress.none;
    _stress[muscleId] = current.next;
    notifyListeners();
  }

  Future<void> _loadPaths() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _paths = await _repository.getPaths(isFront: _isFront);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
