import 'package:powerflix/features/muscle_map/data/datasources/body_map_asset_datasource.dart';
import 'package:powerflix/features/muscle_map/domain/models/body_sex.dart';
import 'package:powerflix/features/muscle_map/domain/models/body_side.dart';
import 'package:powerflix/features/muscle_map/domain/models/figure_outline_path_data.dart';
import 'package:powerflix/features/muscle_map/domain/models/muscle_region_data.dart';
import 'package:powerflix/features/muscle_map/domain/repositories/body_map_repository.dart';

class BodyMapRepositoryImpl extends BodyMapRepository {
  final _datasource = BodyMapAssetDatasource();

  BodySide? _cachedSide;
  BodySex? _cachedSex;
  BodyMapData? _cache;

  Future<BodyMapData> _load({required BodySide side, required BodySex sex}) async {
    if (_cache == null || _cachedSide != side || _cachedSex != sex) {
      _cache = await _datasource.load(side: side, sex: sex);
      _cachedSide = side;
      _cachedSex = sex;
    }
    return _cache!;
  }

  @override
  Future<List<MuscleRegionData>> getMuscleRegions({
    required BodySide side,
    required BodySex sex,
  }) async =>
      (await _load(side: side, sex: sex)).regions;

  @override
  Future<FigureOutlinePathData> getFigureOutline({
    required BodySide side,
    required BodySex sex,
  }) async =>
      (await _load(side: side, sex: sex)).outline;
}
