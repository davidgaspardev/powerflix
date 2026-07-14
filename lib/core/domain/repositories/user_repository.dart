import 'package:moveflix/core/domain/models/user.dart';

abstract class UserRepository {
  Future<UserModel?> getUser();
  Future<void> saveUser(UserModel user);
}
