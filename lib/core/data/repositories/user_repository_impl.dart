import 'package:powerflix/core/data/datasources/user_local_datasource.dart';
import 'package:powerflix/core/domain/models/user.dart';
import 'package:powerflix/core/domain/models/user_preferences.dart';
import 'package:powerflix/core/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDatasource _datasource;

  UserRepositoryImpl(this._datasource);

  @override
  Future<UserModel?> getUser() => _datasource.getUser();

  @override
  Future<void> saveUser(UserModel user) => _datasource.saveUser(user);

  @override
  Future<UserPreferences> getPreferences() => _datasource.getPreferences();

  @override
  Future<void> savePreferences(UserPreferences prefs) =>
      _datasource.savePreferences(prefs);

}
