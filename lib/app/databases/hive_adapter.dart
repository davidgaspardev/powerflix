import 'package:hive/hive.dart';
import 'package:moveflix/core/domain/models/user.dart';
import 'package:moveflix/core/domain/models/user_preferences.dart';
import 'package:moveflix/features/workout/domain/models/workout_plan.dart';

void loadTypeAdapters() {
  _WorkoutPlanTypeAdapter.registerTypeAdapter();
  _UserModelTypeAdapter.registerTypeAdapter();
  _UserPreferencesTypeAdapter.registerTypeAdapter();
}

class _WorkoutPlanTypeAdapter extends TypeAdapter<WorkoutPlan> {
  static void registerTypeAdapter() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(_WorkoutPlanTypeAdapter());
    }
  }

  @override
  int get typeId => 0;

  @override
  WorkoutPlan read(BinaryReader reader) {
    return WorkoutPlan.fromMap(Map<String, dynamic>.from(reader.readMap()));
  }

  @override
  void write(BinaryWriter writer, WorkoutPlan data) {
    writer.writeMap(data.toMap());
  }
}

class _UserModelTypeAdapter extends TypeAdapter<UserModel> {
  static void registerTypeAdapter() {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(_UserModelTypeAdapter());
    }
  }

  @override
  int get typeId => 1;

  @override
  UserModel read(BinaryReader reader) {
    return UserModel.fromMap(Map<String, dynamic>.from(reader.readMap()));
  }

  @override
  void write(BinaryWriter writer, UserModel data) {
    writer.writeMap(data.toMap());
  }
}

class _UserPreferencesTypeAdapter extends TypeAdapter<UserPreferences> {
  static void registerTypeAdapter() {
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(_UserPreferencesTypeAdapter());
    }
  }

  @override
  int get typeId => 2;

  @override
  UserPreferences read(BinaryReader reader) {
    return UserPreferences.fromMap(Map<String, dynamic>.from(reader.readMap()));
  }

  @override
  void write(BinaryWriter writer, UserPreferences data) {
    writer.writeMap(data.toMap());
  }
}
