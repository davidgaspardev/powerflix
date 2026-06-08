import 'package:powerflix/features/muscle_map/domain/models/muscle_path_data.dart';

abstract class MuscleMapRepository {
  Future<List<MusclePathData>> getPaths({required bool isFront});
}
