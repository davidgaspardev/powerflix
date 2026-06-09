enum MuscleStress { none, low, medium, high }

extension MuscleStressExtension on MuscleStress {
  MuscleStress get next {
    const cycle = MuscleStress.values;
    return cycle[(index + 1) % cycle.length];
  }
}
