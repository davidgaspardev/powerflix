import 'package:flutter_test/flutter_test.dart';
import 'package:powerflix/core/data/datasources/user_local_datasource.dart';
import 'package:powerflix/core/data/repositories/user_repository_impl.dart';
import 'package:powerflix/core/domain/models/user.dart';
import 'package:powerflix/core/domain/models/user_preferences.dart';

class _FakeUserLocalDatasource implements UserLocalDatasource {
  UserModel? _user;
  UserPreferences _prefs = const UserPreferences();

  @override
  Future<UserModel?> getUser() async => _user;

  @override
  Future<void> saveUser(UserModel user) async => _user = user;

  @override
  Future<UserPreferences> getPreferences() async => _prefs;

  @override
  Future<void> savePreferences(UserPreferences prefs) async => _prefs = prefs;
}

void main() {
  group('UserRepositoryImpl', () {
    test('getPreferences returns empty preferences by default', () async {
      final repo = UserRepositoryImpl(_FakeUserLocalDatasource());
      final prefs = await repo.getPreferences();
      expect(prefs.favoriteWorkoutIds, isEmpty);
    });

    test('savePreferences persists and getPreferences retrieves', () async {
      final repo = UserRepositoryImpl(_FakeUserLocalDatasource());
      await repo.savePreferences(
        const UserPreferences(favoriteWorkoutIds: ['plan-1', 'plan-2']),
      );
      final prefs = await repo.getPreferences();
      expect(prefs.favoriteWorkoutIds, ['plan-1', 'plan-2']);
    });

    test('getUser returns null when no user saved', () async {
      final repo = UserRepositoryImpl(_FakeUserLocalDatasource());
      expect(await repo.getUser(), isNull);
    });
  });
}
