import 'package:hive/hive.dart';
import 'package:powerflix/core/domain/models/workout_plan.dart';

void loadTypeAdapters() {
  _WorkoutPlanTypeAdapter.registerTypeAdapter();
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
  WorkoutPlan read(BinaryReader binaryReader) {
    return WorkoutPlan.fromMap(
        Map<String, dynamic>.from(binaryReader.readMap()));
  }

  @override
  void write(BinaryWriter binaryWriter, WorkoutPlan data) {
    binaryWriter.writeMap(data.toMap());
  }
}
