import 'package:flutter/foundation.dart';
import 'package:moveflix/core/domain/models/body_sex.dart';
import 'package:moveflix/core/domain/models/muscle_group.dart';
import 'package:moveflix/features/body_map/domain/models/body_side.dart';
import 'package:moveflix/features/body_map/domain/models/figure_outline_path_data.dart';
import 'package:moveflix/features/body_map/domain/models/muscle_region_data.dart';
import 'package:moveflix/features/body_map/domain/repositories/body_map_repository.dart';

class BodyMapViewModel extends ChangeNotifier {
  final BodyMapRepository _repository;

  BodyMapViewModel(this._repository);

  List<MuscleRegionData> _regions = [];
  List<MuscleRegionData> get regions => List.unmodifiable(_regions);

  FigureOutlinePathData? _outline;
  FigureOutlinePathData? get outline => _outline;

  Map<MuscleGroup, int> _stressByGroup = {};
  Map<MuscleGroup, int> get stressByGroup => Map.unmodifiable(_stressByGroup);

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

  /// Applies a `workout`-computed stress map (1-10 per [MuscleGroup]) to the
  /// rendered regions. Bilateral muscles are keyed once and apply to both
  /// left/right regions; central muscles apply directly.
  void applyStress(Map<MuscleGroup, int> stressByGroup) {
    _stressByGroup = stressByGroup;
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
