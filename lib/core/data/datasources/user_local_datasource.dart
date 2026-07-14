import 'package:hive/hive.dart';
import 'package:moveflix/core/domain/models/user.dart';

class UserLocalDatasource {
  static const _userBox = 'user';
  static const _key = 'data';

  Future<UserModel?> getUser() async {
    final box = await Hive.openBox<UserModel>(_userBox);
    return box.get(_key);
  }

  Future<void> saveUser(UserModel user) async {
    final box = await Hive.openBox<UserModel>(_userBox);
    await box.put(_key, user);
  }
}
