import 'package:moveflix/core/data/datasources/user_local_datasource.dart';
import 'package:moveflix/core/domain/models/user.dart';
import 'package:moveflix/core/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDatasource _datasource;

  UserRepositoryImpl(this._datasource);

  @override
  Future<UserModel> getUser() async {
    final user = await _datasource.getUser();
    if (user == null) {
      throw Exception('User not found');
    }

    return user;
  }

  @override
  Future<bool> hasUser() async {
    return (await _datasource.getUser()) != null;
  }

  @override
  Future<void> saveUser(UserModel user) => _datasource.saveUser(user);
}
