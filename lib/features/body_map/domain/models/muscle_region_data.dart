import 'package:moveflix/core/domain/models/muscle_group.dart';
import 'package:moveflix/core/domain/models/muscle_side.dart';
import 'package:moveflix/features/body_map/domain/models/path_data.dart';

class MuscleRegionData extends PathData {
  final MuscleGroup muscleGroup;
  final MuscleSide side;

  const MuscleRegionData({
    required this.muscleGroup,
    required this.side,
    required super.path,
  });
}
