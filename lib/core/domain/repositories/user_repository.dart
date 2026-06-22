import 'package:moveflix/core/domain/models/user.dart';
import 'package:moveflix/core/domain/models/user_preferences.dart';

abstract class UserRepository {
  Future<UserModel?> getUser();
  Future<void> saveUser(UserModel user);
  Future<UserPreferences> getPreferences();
  Future<void> savePreferences(UserPreferences prefs);
}
