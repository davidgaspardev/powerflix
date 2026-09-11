import 'package:moveflix/core/domain/models/body_region.dart';
import 'package:moveflix/core/domain/models/region_side.dart';
import 'package:moveflix/features/body_map/domain/models/path_data.dart';

/// One shaded path on the body map: which [BodyRegion] it belongs to, which
/// [RegionSide] of the body it is on, and its geometry.
class BodyRegionData extends PathData {
  final BodyRegion region;
  final RegionSide side;

  const BodyRegionData({
    required this.region,
    required this.side,
    required super.path,
  });
}
