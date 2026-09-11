import 'dart:convert';

import 'package:moveflix/core/domain/model.dart';
import 'package:moveflix/core/domain/models/body_region.dart';

// ── enums ──────────────────────────────────────────────────────────────────

enum Difficulty { light, soft, hard }

extension DifficultyExtension on Difficulty {
  String toValue() {
    switch (this) {
      case Difficulty.light:
        return 'LIGHT';
      case Difficulty.soft:
        return 'SOFT';
      case Difficulty.hard:
        return 'HARD';
    }
  }

  static Difficulty fromValue(String value) {
    switch (value.toUpperCase()) {
      case 'LIGHT':
        return Difficulty.light;
      case 'SOFT':
        return Difficulty.soft;
      case 'HARD':
        return Difficulty.hard;
      default:
        throw Exception('Unknown difficulty: $value');
    }
  }
}

// ── models ─────────────────────────────────────────────────────────────────

class Technique extends Model {
  final String title;
  final String description;

  const Technique({required this.title, required this.description});

  static Technique fromMap(Map<String, dynamic> map) {
    try {
      return Technique(
        title: map['title'] as String,
        description: map['description'] as String,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Map<String, dynamic> toMap() => {'title': title, 'description': description};

  @override
  String toJson() => jsonEncode(toMap());
}

class Exercise extends Model {
  final int order;
  final String name;
  final String? videoUrl;
  final List<Technique> techniques;

  const Exercise({
    required this.order,
    required this.name,
    this.videoUrl,
    this.techniques = const [],
  });

  static Exercise fromMap(Map<String, dynamic> map) {
    try {
      return Exercise(
        order: map['order'] as int,
        name: map['name'] as String,
        videoUrl: map['videoUrl'] as String?,
        techniques: map['techniques'] != null
            ? (map['techniques'] as List)
                .map<Technique>(
                  (t) => Technique.fromMap(Map<String, dynamic>.from(t)),
                )
                .toList()
            : [],
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'order': order, 'name': name};
    if (videoUrl != null) map['videoUrl'] = videoUrl;
    if (techniques.isNotEmpty) {
      map['techniques'] =
          techniques.map<Map<String, dynamic>>((t) => t.toMap()).toList();
    }
    return map;
  }

  @override
  String toJson() => jsonEncode(toMap());
}

class SetConfig extends Model {
  final int sets;
  final int? reps;
  final int? restSeconds;

  const SetConfig({required this.sets, this.reps, this.restSeconds});

  static SetConfig fromMap(Map<String, dynamic> map) {
    try {
      return SetConfig(
        sets: map['sets'] as int,
        reps: map['reps'] as int?,
        restSeconds: map['restSeconds'] as int?,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'sets': sets};
    if (reps != null) map['reps'] = reps;
    if (restSeconds != null) map['restSeconds'] = restSeconds;
    return map;
  }

  @override
  String toJson() => jsonEncode(toMap());
}

class DifficultyTier extends Model {
  final Difficulty difficulty;
  final String description;
  final SetConfig volume;
  final List<Exercise> exercises;
  final String? warmupNote;

  const DifficultyTier({
    required this.difficulty,
    required this.description,
    required this.volume,
    required this.exercises,
    this.warmupNote,
  });

  static DifficultyTier fromMap(Map<String, dynamic> map) {
    try {
      return DifficultyTier(
        difficulty: DifficultyExtension.fromValue(map['difficulty'] as String),
        description: map['description'] as String,
        volume: SetConfig.fromMap(Map<String, dynamic>.from(map['volume'])),
        exercises: (map['exercises'] as List)
            .map<Exercise>(
              (e) => Exercise.fromMap(Map<String, dynamic>.from(e)),
            )
            .toList(),
        warmupNote: map['warmupNote'] as String?,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'difficulty': difficulty.toValue(),
      'description': description,
      'volume': volume.toMap(),
      'exercises': exercises.map<Map<String, dynamic>>((e) => e.toMap()).toList(),
    };
    if (warmupNote != null) map['warmupNote'] = warmupNote;
    return map;
  }

  @override
  String toJson() => jsonEncode(toMap());
}

class WorkoutPlan extends Model {
  final String id;
  final String name;
  final String description;
  final String coverUrl;

  /// Body regions this plan targets, used to render stress on the body map
  /// for favorited workouts. See [BodyRegion].
  final List<BodyRegion> primaryRegions;
  final List<DifficultyTier> levels;

  const WorkoutPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.coverUrl,
    this.primaryRegions = const [],
    required this.levels,
  });

  static WorkoutPlan fromMap(Map<String, dynamic> map) {
    try {
      return WorkoutPlan(
        id: map['id'] as String,
        name: map['name'] as String,
        description: map['description'] as String,
        coverUrl: map['coverUrl'] as String,
        primaryRegions: (map['primaryRegions'] as List? ?? [])
            .map<BodyRegion>((r) => BodyRegion.values.byName(r as String))
            .toList(),
        levels: (map['levels'] as List)
            .map<DifficultyTier>(
              (l) => DifficultyTier.fromMap(Map<String, dynamic>.from(l)),
            )
            .toList(),
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  static WorkoutPlan fromJson(String json) {
    final map = jsonDecode(json) as Map<String, dynamic>;
    return WorkoutPlan.fromMap(map);
  }

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'coverUrl': coverUrl,
        'primaryRegions': primaryRegions.map((r) => r.name).toList(),
        'levels': levels.map<Map<String, dynamic>>((l) => l.toMap()).toList(),
      };

  @override
  String toJson() => jsonEncode(toMap());
}
