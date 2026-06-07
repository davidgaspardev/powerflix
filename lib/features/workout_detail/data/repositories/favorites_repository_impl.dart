import 'package:powerflix/features/workout_detail/data/datasources/favorites_datasource.dart';
import 'package:powerflix/features/workout_detail/domain/repositories/favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesDatasource _datasource;

  FavoritesRepositoryImpl(this._datasource);

  @override
  Future<bool> isFavorite(String id) => _datasource.isFavorite(id);

  @override
  Future<void> setFavorite(String id, bool value) => _datasource.setFavorite(id, value);
}
