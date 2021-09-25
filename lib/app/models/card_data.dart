/// Standard package
import 'dart:convert';
/// Internal package
import 'package:powerflix/app/helpers/abstraction/model.dart';

/// Card Data [Model]
class CardData extends Model {

  final String id;
  final String name;
  final String description;
  final String cover;
  final List<ModuleData> modules;

  /// Constructor
  ///
  /// Data input to [CardData]
  const CardData({
    required this.id,
    required this.name,
    required this.description,
    required this.cover,
    required this.modules
  });

  /// Method to initilize [CardData] with [Map]
  static CardData fromMap(Map<String, dynamic> map) {
    try {
      return CardData(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        cover: map['cover'],
        modules: List<Map<String, dynamic>>.from(map['modules']).map<ModuleData>((Map<String, dynamic> data) {
          return ModuleData.fromMap(data);
        }).toList()
      );
    } catch(e) {
      throw Exception(e);
    }
  }

  /// To json
  ///
  /// Data output from [CardData]
  @override
  String toJson() {
    return jsonEncode(this.toMap());
  }

  /// To Map
  ///
  /// Data output from [CardData]
  @override
  Map<String, dynamic> toMap() {
    return {
      "name": this.name,
      "description": this.description,
      "cover": this.cover,
      "modules": this.modules.map<Map<String, dynamic>>((ModuleData module) {
        return module.toMap();
      }).toList()
    };
  }

}

/// Module Data [Model]
class ModuleData extends Model {

  final String level;
  final String description;
  final FrequencyData frequency;
  final List<ExerciseData> exercises;

  /// Constructor
  ///
  /// Data input to [ModuleData]
  const ModuleData({
    required this.level,
    required this.description,
    required this.frequency,
    required this.exercises
  });

  /// Method to initilize [ModuleData] with [Map]
  static ModuleData fromMap(Map<String, dynamic> map) {
    try {
      return ModuleData(
        level: map['level'],
        description: map['description'],
        frequency: FrequencyData.fromMap(map['frequency']),
        exercises: List<Map<String, dynamic>>.from(map['exercises']).map<ExerciseData>((Map<String, dynamic> data) {
          return ExerciseData.fromMap(data);
        }).toList(),
      );
    } catch(e) {
      throw Exception(e);
    }
  }

  /// To json
  ///
  /// Data output from [ModuleData]
  @override
  String toJson() {
    return jsonEncode(this.toMap());
  }

  /// To map
  ///
  /// Data output from [ModuleData]
  @override
  Map<String, dynamic> toMap() {
    return {
      "level": this.level,
      "description": this.description,
      "frequency": this.frequency.toMap(),
      "exercises": this.exercises.map<Map<String, dynamic>>((ExerciseData exercise) {
        return exercise.toMap();
      }).toList(),
    };
  }
}

/// Frequency Data [Model]
class FrequencyData extends Model {

  final int repetition;
  final int series;

  /// Constructor
  ///
  /// Data input to [FrequencyData]
  const FrequencyData({
    required this.repetition,
    required this.series
  });

  /// Method to initilize [FrequencyData] with [Map]
  static FrequencyData fromMap(Map<String, int> map) {
    try {
      return FrequencyData(
        repetition: map['repetition'] as int,
        series: map['series'] as int,
      );
    } catch(e) {
      throw Exception(e);
    }
  }

  /// To json
  ///
  /// Data output from [FrequencyData]
  @override
  String toJson() {
    return jsonEncode(this.toMap());
  }

  /// To map
  ///
  /// Data output from [FrequencyData]
  @override
  Map<String, int> toMap() {
    return {
      "repetition": this.repetition,
      "series": this.series
    };
  }
}

/// Exercise Data [Model]
class ExerciseData extends Model {

  final int order;
  final String name;

  /// Constructor
  ///
  /// Data input to [ExerciseData]
  const ExerciseData({
    required this.order,
    required this.name
  });

  /// Method to initilize [ExerciseData] with [Map]
  static ExerciseData fromMap(Map<String, dynamic> map) {
    try {
      return ExerciseData(
        order: map['order'] as int,
        name: map['name'] as String,
      );
    } catch(e) {
      throw Exception(e);
    }
  }

  /// To json
  ///
  /// Data output from [ExerciseData]
  @override
  String toJson() {
    return jsonEncode(this.toMap());
  }

  /// To map
  ///
  /// Data output from [ExerciseData]
  @override
  Map<String, dynamic> toMap() {
    return {
      "order": this.order,
      "name": this.name
    };
  }
}