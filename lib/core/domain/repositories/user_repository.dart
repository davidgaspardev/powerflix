import 'package:moveflix/core/domain/models/user.dart';

abstract class UserRepository {
  Future<UserModel> getUser();
  Future<bool> hasUser();
  Future<void> saveUser(UserModel user);
}
