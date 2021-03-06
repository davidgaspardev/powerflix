/// Standard package
import 'dart:convert';
/// Internal package
import 'package:powerflix/app/helpers/abstraction/model.dart';

/// Card Data [Model]
class CardflixData extends Model {

  final String id;
  final String name;
  final String description;
  final String cover;
  final List<ModuleData> modules;

  /// Constructor
  ///
  /// Data input to [CardflixData]
  const CardflixData({
    required this.id,
    required this.name,
    required this.description,
    required this.cover,
    required this.modules
  });

  /// Method to initilize [CardflixData] with [Map]
  static CardflixData fromMap(Map<String, dynamic> map) {
    try {
      return CardflixData(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        cover: map['cover'],
        modules: (map['modules'] as List).map<ModuleData>((data) {
          return ModuleData.fromMap(Map<String, dynamic>.from(data));
        }).toList()
      );
    } catch(e) {
      throw Exception(e);
    }
  }

  /// To json
  ///
  /// Data output from [CardflixData]
  @override
  String toJson() {
    return jsonEncode(this.toMap());
  }

  /// To Map
  ///
  /// Data output from [CardflixData]
  @override
  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
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
        frequency: FrequencyData.fromMap(Map<String, int>.from(map['frequency'])),
        exercises: (map['exercises'] as List)
          .map<ExerciseData>((data) {
            return ExerciseData.fromMap(Map<String, dynamic>.from(data));
          })
          .toList(),
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
  final List<FeatureData> features;
  final String? link;

  /// Constructor
  ///
  /// Data input to [ExerciseData]
  const ExerciseData({
    required this.order,
    required this.name,
    this.features = const [],
    this.link
  });

  /// Method to initilize [ExerciseData] with [Map]
  static ExerciseData fromMap(Map<String, dynamic> map) {
    try {
      return ExerciseData(
        order: map['order'] as int,
        name: map['name'] as String,
        features: map['features'] != null
        ? (map['features'] as List)
          .map<FeatureData>((map) {
            return FeatureData.fromMap(Map<String, String>.from(map));
          }).toList()
        : [],
        link: map['link']
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
    var map = <String, dynamic>{
      "order": this.order,
      "name": this.name,
    };

    if(this.link != null) map["link"] = this.link;
    if(this.features.length > 0) map["features"] = this.features
      .map<Map<String, String>>((FeatureData data) => data.toMap())
      .toList();

    return map;
  }
}

/// Exercise Data [Model]
class FeatureData extends Model {

  final String name;
  final String description;

  /// Constructor
  ///
  /// Data input to [FeatureData]
  const FeatureData({
    required this.name,
    required this.description
  });

  /// Method to initilize [FeatureData] with [Map]
  static FeatureData fromMap(Map<String, String> map) {
    try {
      return FeatureData(
        name: map['name'] as String,
        description: map['description'] as String,
      );
    } catch(e) {
      throw Exception(e);
    }
  }

  /// To json
  ///
  /// Data output from [FeatureData]
  @override
  String toJson() {
    return jsonEncode(this.toMap());
  }

  /// To map
  ///
  /// Data output from [FeatureData]
  @override
  Map<String, String> toMap() {
    return {
      "name": this.name,
      "description": this.description
    };
  }
}