import 'package:powerflix/features/muscle_map/domain/models/muscle_path_data.dart';

abstract class MuscleMapDatasource {
  Future<List<MusclePathData>> fetchPaths({required bool isFront});
}
