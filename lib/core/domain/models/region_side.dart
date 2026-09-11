/// Which side of the body a [BodyRegion] path sits on.
///
/// Paired regions (arms, legs, shoulders…) are drawn twice and carry
/// [left]/[right]; midline regions (abdomen, traps band, upper/lower back)
/// are a single path and carry [center].
enum RegionSide {
  left,
  right,
  center;

  /// Suffix used in the SVG `id` — `''` for [center], which has no pair.
  String get svgSuffix => this == center ? '' : '_$name';
}
