/// A named area of the body that the map can shade.
///
/// These are *regions*, not individual muscles: the SVG art is drawn at
/// region fidelity, so `upperBack` covers mid-trapezius + rhomboids, `flank`
/// covers obliques + serratus, and so on. Workouts declare the regions they
/// target and `body_map` shades them — see `lib/features/body_map/README.md`.
///
/// [svgId] is the `id` root used in `assets/image/svg/*_muscle_map_*.svg`.
/// Paired regions appear there as `<svgId>_left` / `<svgId>_right`; midline
/// regions as plain `<svgId>`. The same region sits in the same place on the
/// male and female art, so nothing downstream needs to branch on [BodySex].
enum BodyRegion {
  // ── front ──────────────────────────────────────────────────────────────
  neck('neck'),
  frontShoulder('front_shoulder'),
  chest('chest'),
  frontUpperArm('front_upper_arm'),
  abdomen('abdomen'),
  flank('flank'),
  quads('quads'),
  shin('shin'),

  // ── back ───────────────────────────────────────────────────────────────
  backShoulder('back_shoulder'),
  upperBack('upper_back'),
  lowerBack('lower_back'),
  lats('lats'),
  backUpperArm('back_upper_arm'),
  glutes('glutes'),
  hamstrings('hamstrings'),
  calves('calves'),

  // ── both views ─────────────────────────────────────────────────────────
  traps('traps'),
  forearm('forearm');

  const BodyRegion(this.svgId);

  /// `id` root of this region's paths in the body map SVGs.
  final String svgId;

  static final Map<String, BodyRegion> _bySvgId = {
    for (final region in values) region.svgId: region,
  };

  /// Resolves an SVG `id` root (no `_left`/`_right` suffix) to a region,
  /// or `null` when the id is not a body region.
  static BodyRegion? fromSvgId(String svgId) => _bySvgId[svgId];
}
