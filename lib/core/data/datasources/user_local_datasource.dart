import 'package:hive/hive.dart';
import 'package:moveflix/core/domain/models/user.dart';
import 'package:moveflix/core/domain/models/user_preferences.dart';

class UserLocalDatasource {
  static const _userBox = 'user';
  static const _prefsBox = 'user_preferences';
  static const _key = 'data';

  Future<UserModel?> getUser() async {
    final box = await Hive.openBox<UserModel>(_userBox);
    return box.get(_key);
  }

  Future<void> saveUser(UserModel user) async {
    final box = await Hive.openBox<UserModel>(_userBox);
    await box.put(_key, user);
  }

  Future<UserPreferences> getPreferences() async {
    final box = await Hive.openBox<UserPreferences>(_prefsBox);
    return box.get(_key) ?? const UserPreferences();
  }

  Future<void> savePreferences(UserPreferences prefs) async {
    final box = await Hive.openBox<UserPreferences>(_prefsBox);
    await box.put(_key, prefs);
  }
}
