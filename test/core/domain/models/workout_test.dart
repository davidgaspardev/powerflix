import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:powerflix/core/domain/models/workout_plan.dart';

List<Map<String, dynamic>> _loadFixture() {
  final file = File('lib/app/assets/data/workouts.json');
  final raw = jsonDecode(file.readAsStringSync()) as List;
  return raw.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList();
}

void main() {
  const _biSet = 'Significa realizar dois movimentos seguidos sem intervalos á cada repetição';

  late List<Map<String, dynamic>> fixture;

  setUpAll(() {
    fixture = _loadFixture();
  });

  group('WorkoutPlan serialization', () {
    test('loads all 8 plans from JSON fixture', () {
      expect(fixture.length, 8);
    });

    test('fromMap → toMap round-trip for each plan', () {
      for (int i = 0; i < fixture.length; i++) {
        final plan = WorkoutPlan.fromMap(fixture[i]);
        print('\nPlan $i (${plan.name}): ${plan.toJson()}');
        expect(plan.toMap(), fixture[i]);
      }
    });

    test('toJson produces a decodable string', () {
      for (final data in fixture) {
        final plan = WorkoutPlan.fromMap(data);
        final decoded = jsonDecode(plan.toJson()) as Map<String, dynamic>;
        expect(decoded['id'], data['id']);
      }
    });

    test('null reps is omitted from toMap (Abdômen Chapado hard tier)', () {
      final data = fixture.firstWhere((p) => p['id'] == 'egywe8gfs87gf7');
      final plan = WorkoutPlan.fromMap(data);
      final hardTier = plan.toMap()['levels'][2] as Map<String, dynamic>;
      final volume = hardTier['volume'] as Map<String, dynamic>;
      expect(volume.containsKey('reps'), isFalse);
    });

    test('techniques are serialized and restored correctly', () {
      final data = fixture.firstWhere((p) => p['id'] == '4y73y475y3884y3');
      final plan = WorkoutPlan.fromMap(data);
      final softTier = plan.levels[1];
      final exercise = softTier.exercises[0];
      expect(exercise.techniques.length, 1);
      expect(exercise.techniques[0].title, 'BI-SET 4x9 + 9');
      expect(exercise.techniques[0].description, _biSet);
    });

    test('Difficulty enum round-trips through toValue / fromValue', () {
      expect(DifficultyExtension.fromValue('LIGHT'), Difficulty.light);
      expect(DifficultyExtension.fromValue('SOFT'), Difficulty.soft);
      expect(DifficultyExtension.fromValue('HARD'), Difficulty.hard);
      expect(Difficulty.light.toValue(), 'LIGHT');
      expect(Difficulty.soft.toValue(), 'SOFT');
      expect(Difficulty.hard.toValue(), 'HARD');
    });
  });
}
