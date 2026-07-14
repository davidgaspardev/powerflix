import 'package:moveflix/core/data/datasources/user_local_datasource.dart';
import 'package:moveflix/core/domain/models/user.dart';
import 'package:moveflix/core/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDatasource _datasource;

  UserRepositoryImpl(this._datasource);

  @override
  Future<UserModel?> getUser() => _datasource.getUser();

  @override
  Future<void> saveUser(UserModel user) => _datasource.saveUser(user);
}
