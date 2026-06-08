import 'package:flutter_test/flutter_test.dart';
import 'package:powerflix/core/data/datasources/favorites_datasource.dart';
import 'package:powerflix/core/data/repositories/favorites_repository_impl.dart';

class _FakeFavoritesDatasource implements FavoritesDatasource {
  final Map<String, bool> _data = {};

  @override
  Future<bool> isFavorite(String id) async => _data[id] ?? false;

  @override
  Future<void> setFavorite(String id, bool value) async => _data[id] = value;
}

void main() {
  group('FavoritesRepositoryImpl', () {
    test('returns false for unknown id', () async {
      final repo = FavoritesRepositoryImpl(_FakeFavoritesDatasource());
      expect(await repo.isFavorite('unknown'), isFalse);
    });

    test('returns true after setFavorite(true)', () async {
      final repo = FavoritesRepositoryImpl(_FakeFavoritesDatasource());
      await repo.setFavorite('plan-1', true);
      expect(await repo.isFavorite('plan-1'), isTrue);
    });

    test('returns false after setFavorite(false)', () async {
      final repo = FavoritesRepositoryImpl(_FakeFavoritesDatasource());
      await repo.setFavorite('plan-1', true);
      await repo.setFavorite('plan-1', false);
      expect(await repo.isFavorite('plan-1'), isFalse);
    });

    test('ids are independent', () async {
      final repo = FavoritesRepositoryImpl(_FakeFavoritesDatasource());
      await repo.setFavorite('plan-1', true);
      expect(await repo.isFavorite('plan-2'), isFalse);
    });
  });
}
