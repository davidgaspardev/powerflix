/// Visual stress tier for a [BodyRegion] on the body map.
///
/// This is a pure display mapping — the source of truth for stress is the
/// 1-10 scale computed by `workout` and applied via
/// `BodyMapViewModel.applyStress`.
enum StressLevel {
  none,
  low,
  medium,
  high;

  /// Maps a workout-computed stress level (1-10, 0/negative treated as none)
  /// to the color tier used to paint a region.
  static StressLevel fromLevel(int level) {
    if (level <= 0) return StressLevel.none;
    if (level <= 3) return StressLevel.low;
    if (level <= 6) return StressLevel.medium;
    return StressLevel.high;
  }
}
