import 'package:hive/hive.dart';
import 'package:powerflix/core/data/datasources/favorites_datasource.dart';

class FavoritesLocalDatasource implements FavoritesDatasource {
  static const _boxName = 'favorites';

  @override
  Future<bool> isFavorite(String id) async {
    final box = await Hive.openBox<bool>(_boxName);
    return box.get(id) ?? false;
  }

  @override
  Future<void> setFavorite(String id, bool value) async {
    final box = await Hive.openBox<bool>(_boxName);
    await box.put(id, value);
  }
}
