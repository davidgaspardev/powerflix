import 'package:flutter_test/flutter_test.dart';
import 'package:moveflix/core/data/datasources/user_local_datasource.dart';
import 'package:moveflix/core/data/repositories/user_repository_impl.dart';
import 'package:moveflix/core/domain/models/body_sex.dart';
import 'package:moveflix/core/domain/models/user.dart';

class _FakeUserLocalDatasource implements UserLocalDatasource {
  UserModel? _user;

  @override
  Future<UserModel?> getUser() async => _user;

  @override
  Future<void> saveUser(UserModel user) async => _user = user;
}

void main() {
  group('UserRepositoryImpl', () {
    test('getUser returns null when no user saved', () async {
      final repo = UserRepositoryImpl(_FakeUserLocalDatasource());
      expect(await repo.getUser(), isNull);
    });

    test('saveUser persists and getUser retrieves the same user', () async {
      final repo = UserRepositoryImpl(_FakeUserLocalDatasource());
      final user = UserModel(
        name: 'David',
        sex: BodySex.male,
        birthday: DateTime(1999, 2, 16),
        weight: 80.0,
        height: 175.0,
      );
      await repo.saveUser(user);
      final retrieved = await repo.getUser();
      expect(retrieved, isNotNull);
      expect(retrieved!.name, 'David');
      expect(retrieved.weight, 80.0);
      expect(retrieved.height, 175.0);
    });

    test('saveUser overwrites previous user', () async {
      final repo = UserRepositoryImpl(_FakeUserLocalDatasource());
      await repo.saveUser(UserModel(
        name: 'First',
        sex: BodySex.female,
        birthday: DateTime(2000),
        weight: 60.0,
        height: 165.0,
      ));
      await repo.saveUser(UserModel(
        name: 'Second',
        sex: BodySex.male,
        birthday: DateTime(1995),
        weight: 75.0,
        height: 180.0,
      ));
      final user = await repo.getUser();
      expect(user!.name, 'Second');
    });
  });
}
