/// Visual stress tier for a [MuscleGroup] region on the body map.
///
/// This is a pure display mapping — the source of truth for stress is the
/// 1-10 scale computed by `workout` and applied via
/// `BodyMapViewModel.applyStress`.
enum MuscleStress {
  none,
  low,
  medium,
  high;

  /// Maps a workout-computed stress level (1-10, 0/negative treated as none)
  /// to the color tier used to paint a muscle region.
  static MuscleStress fromLevel(int level) {
    if (level <= 0) return MuscleStress.none;
    if (level <= 3) return MuscleStress.low;
    if (level <= 6) return MuscleStress.medium;
    return MuscleStress.high;
  }
}
