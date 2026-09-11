import 'package:flutter/foundation.dart';
import 'package:moveflix/core/domain/models/body_region.dart';
import 'package:moveflix/core/domain/models/body_sex.dart';
import 'package:moveflix/features/body_map/domain/models/body_region_data.dart';
import 'package:moveflix/features/body_map/domain/models/body_side.dart';
import 'package:moveflix/features/body_map/domain/models/figure_outline_path_data.dart';
import 'package:moveflix/features/body_map/domain/repositories/body_map_repository.dart';

class BodyMapViewModel extends ChangeNotifier {
  final BodyMapRepository _repository;

  BodyMapViewModel(this._repository);

  List<BodyRegionData> _regions = [];
  List<BodyRegionData> get regions => List.unmodifiable(_regions);

  FigureOutlinePathData? _outline;
  FigureOutlinePathData? get outline => _outline;

  Map<BodyRegion, int> _stressByRegion = {};
  Map<BodyRegion, int> get stressByRegion => Map.unmodifiable(_stressByRegion);

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

  /// Applies a `workout`-computed stress map (1-10 per [BodyRegion]) to the
  /// rendered regions. A region is keyed once and applies to every path that
  /// belongs to it, left and right included.
  void applyStress(Map<BodyRegion, int> stressByRegion) {
    _stressByRegion = stressByRegion;
    notifyListeners();
  }

  Future<void> _load() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _regions = await _repository.getRegions(side: _side, sex: BodySex.male);
      _outline = await _repository.getFigureOutline(side: _side, sex: BodySex.male);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
