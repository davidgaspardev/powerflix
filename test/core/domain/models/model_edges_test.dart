import 'package:flutter_test/flutter_test.dart';
import 'package:moveflix/features/workout/domain/models/workout_plan.dart';

void main() {
  group('Difficulty', () {
    test('fromValue is case-insensitive', () {
      expect(DifficultyExtension.fromValue('light'), Difficulty.light);
      expect(DifficultyExtension.fromValue('SOFT'), Difficulty.soft);
      expect(DifficultyExtension.fromValue('Hard'), Difficulty.hard);
    });

    test('fromValue throws on unknown value', () {
      expect(() => DifficultyExtension.fromValue('EXTREME'), throwsException);
    });

    test('toValue returns uppercase string', () {
      expect(Difficulty.light.toValue(), 'LIGHT');
      expect(Difficulty.soft.toValue(), 'SOFT');
      expect(Difficulty.hard.toValue(), 'HARD');
    });
  });

  group('Technique', () {
    test('fromMap/toMap round-trip', () {
      const t = Technique(title: 'BI-SET', description: 'Two exercises in a row');
      final restored = Technique.fromMap(t.toMap());
      expect(restored.title, t.title);
      expect(restored.description, t.description);
    });

    test('toJson produces a decodable JSON string', () {
      const t = Technique(title: 'Drop Set', description: 'Reduce weight each set');
      final json = t.toJson();
      expect(json, contains('Drop Set'));
      expect(json, contains('Reduce weight each set'));
    });
  });

  group('SetConfig', () {
    test('toMap omits null reps and restSeconds', () {
      const sc = SetConfig(sets: 4);
      final map = sc.toMap();
      expect(map['sets'], 4);
      expect(map.containsKey('reps'), isFalse);
      expect(map.containsKey('restSeconds'), isFalse);
    });

    test('toMap includes reps and restSeconds when set', () {
      const sc = SetConfig(sets: 3, reps: 12, restSeconds: 60);
      final map = sc.toMap();
      expect(map['reps'], 12);
      expect(map['restSeconds'], 60);
    });

    test('fromMap/toMap round-trip with all fields', () {
      const sc = SetConfig(sets: 4, reps: 10, restSeconds: 90);
      final restored = SetConfig.fromMap(sc.toMap());
      expect(restored.sets, 4);
      expect(restored.reps, 10);
      expect(restored.restSeconds, 90);
    });

    test('fromMap/toMap round-trip with only sets', () {
      const sc = SetConfig(sets: 5);
      final restored = SetConfig.fromMap(sc.toMap());
      expect(restored.sets, 5);
      expect(restored.reps, isNull);
      expect(restored.restSeconds, isNull);
    });
  });

  group('Exercise', () {
    test('toMap omits videoUrl when null', () {
      const ex = Exercise(order: 1, name: 'Push-up');
      expect(ex.toMap().containsKey('videoUrl'), isFalse);
    });

    test('toMap omits techniques when empty', () {
      const ex = Exercise(order: 1, name: 'Push-up');
      expect(ex.toMap().containsKey('techniques'), isFalse);
    });

    test('toMap includes videoUrl and techniques when present', () {
      const ex = Exercise(
        order: 2,
        name: 'Cable Fly',
        videoUrl: 'https://example.com/video.mp4',
        techniques: [Technique(title: 'Slow', description: 'Slow eccentric')],
      );
      final map = ex.toMap();
      expect(map['videoUrl'], 'https://example.com/video.mp4');
      expect((map['techniques'] as List), hasLength(1));
    });

    test('fromMap/toMap round-trip preserves all fields', () {
      const ex = Exercise(
        order: 3,
        name: 'Squat',
        videoUrl: 'https://example.com/squat.mp4',
        techniques: [Technique(title: 'Pause', description: 'Pause at bottom')],
      );
      final restored = Exercise.fromMap(ex.toMap());
      expect(restored.order, 3);
      expect(restored.name, 'Squat');
      expect(restored.videoUrl, 'https://example.com/squat.mp4');
      expect(restored.techniques, hasLength(1));
      expect(restored.techniques.first.title, 'Pause');
    });

    test('fromMap with null techniques defaults to empty list', () {
      final ex = Exercise.fromMap({'order': 1, 'name': 'Run', 'techniques': null});
      expect(ex.techniques, isEmpty);
    });
  });

  group('DifficultyTier', () {
    test('toMap omits warmupNote when null', () {
      final tier = DifficultyTier(
        difficulty: Difficulty.light,
        description: 'Easy',
        volume: const SetConfig(sets: 3),
        exercises: const [],
      );
      expect(tier.toMap().containsKey('warmupNote'), isFalse);
    });

    test('toMap includes warmupNote when set', () {
      final tier = DifficultyTier(
        difficulty: Difficulty.hard,
        description: 'Hard',
        volume: const SetConfig(sets: 5, reps: 5),
        exercises: const [],
        warmupNote: 'Warm up 10 min',
      );
      expect(tier.toMap()['warmupNote'], 'Warm up 10 min');
    });

    test('fromMap/toMap round-trip', () {
      final tier = DifficultyTier(
        difficulty: Difficulty.soft,
        description: 'Medium',
        volume: const SetConfig(sets: 4, reps: 8, restSeconds: 45),
        exercises: const [Exercise(order: 1, name: 'Lunge')],
        warmupNote: 'Stretch first',
      );
      final restored = DifficultyTier.fromMap(tier.toMap());
      expect(restored.difficulty, Difficulty.soft);
      expect(restored.description, 'Medium');
      expect(restored.volume.sets, 4);
      expect(restored.exercises, hasLength(1));
      expect(restored.warmupNote, 'Stretch first');
    });
  });

  group('WorkoutPlan', () {
    test('fromMap throws on missing required field', () {
      expect(
        () => WorkoutPlan.fromMap({
          'id': 'x',
          'name': 'x',
          'levels': [],
          // missing: description, coverUrl
        }),
        throwsException,
      );
    });

    test('fromMap/toMap round-trip', () {
      const plan = WorkoutPlan(
        id: 'abc',
        name: 'Full Body',
        description: 'Works everything',
        coverUrl: 'https://example.com/fb.jpg',
        levels: [],
      );
      final restored = WorkoutPlan.fromMap(plan.toMap());
      expect(restored.id, 'abc');
      expect(restored.name, 'Full Body');
      expect(restored.description, 'Works everything');
      expect(restored.coverUrl, 'https://example.com/fb.jpg');
      expect(restored.levels, isEmpty);
    });
  });
}
