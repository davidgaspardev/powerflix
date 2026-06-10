import 'package:powerflix/features/muscle_map/domain/models/body_sex.dart';
import 'package:powerflix/features/muscle_map/domain/models/body_side.dart';
import 'package:powerflix/features/muscle_map/domain/models/figure_outline_path_data.dart';
import 'package:powerflix/features/muscle_map/domain/models/muscle_region_data.dart';
import 'package:powerflix/features/muscle_map/domain/repositories/body_map_repository.dart';

class BodyMapRepositoryImpl extends BodyMapRepository {
  @override
  Future<List<MuscleRegionData>> getMuscleRegions({required BodySide side, required BodySex sex}) async {
    throw UnimplementedError();
  }

  @override
  Future<FigureOutlinePathData> getFigureOutline({required BodySide side, required BodySex sex}) async {
    throw UnimplementedError();
  }
}