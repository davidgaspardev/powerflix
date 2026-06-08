import 'package:powerflix/features/muscle_map/data/datasources/muscle_map_datasource.dart';
import 'package:powerflix/features/muscle_map/domain/models/muscle_path_data.dart';
import 'package:powerflix/features/muscle_map/domain/repositories/muscle_map_repository.dart';

class MuscleMapRepositoryImpl implements MuscleMapRepository {
  final MuscleMapDatasource _datasource;

  MuscleMapRepositoryImpl(this._datasource);

  @override
  Future<List<MusclePathData>> getPaths({required bool isFront}) =>
      _datasource.fetchPaths(isFront: isFront);
}
