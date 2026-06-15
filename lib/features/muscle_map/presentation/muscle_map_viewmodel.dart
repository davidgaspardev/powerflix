import 'package:flutter/foundation.dart';
import 'package:powerflix/core/domain/models/muscle_stress.dart';
import 'package:powerflix/core/domain/models/body_sex.dart';
import 'package:powerflix/features/muscle_map/domain/models/body_side.dart';
import 'package:powerflix/features/muscle_map/domain/models/figure_outline_path_data.dart';
import 'package:powerflix/features/muscle_map/domain/models/muscle_region_data.dart';
import 'package:powerflix/features/muscle_map/domain/repositories/body_map_repository.dart';

class MuscleMapViewModel extends ChangeNotifier {
  final BodyMapRepository _repository;

  MuscleMapViewModel(this._repository);

  List<MuscleRegionData> _regions = [];
  List<MuscleRegionData> get regions => List.unmodifiable(_regions);

  FigureOutlinePathData? _outline;
  FigureOutlinePathData? get outline => _outline;

  final Map<String, MuscleStress> _stress = {};
  Map<String, MuscleStress> get stress => Map.unmodifiable(_stress);

  BodySide _side = BodySide.front;
  BodySide get side => _side;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  bool get hasError => _error != null;

  Future<void> init() => _load();

  Future<void> toggleSide() async {
    _side = _side == BodySide.front ? BodySide.back : BodySide.front;
    await _load();
  }

  void onMuscleTap(String muscleId) {
    final current = _stress[muscleId] ?? MuscleStress.none;
    _stress[muscleId] = current.next;
    notifyListeners();
  }

  Future<void> _load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _regions = await _repository.getMuscleRegions(side: _side, sex: BodySex.male);
      _outline = await _repository.getFigureOutline(side: _side, sex: BodySex.male);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
