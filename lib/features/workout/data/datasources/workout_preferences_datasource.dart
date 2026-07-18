import 'package:hive/hive.dart';
import 'package:moveflix/features/workout/domain/models/workout_preferences.dart';

class WorkoutPreferencesDatasource {
  static const _box = 'user_preferences';
  static const _key = 'data';

  Future<WorkoutPreferences> getPreferences() async {
    final box = await Hive.openBox<WorkoutPreferences>(_box);
    return box.get(_key) ?? const WorkoutPreferences();
  }

  Future<void> savePreferences(WorkoutPreferences prefs) async {
    final box = await Hive.openBox<WorkoutPreferences>(_box);
    await box.put(_key, prefs);
  }
}
