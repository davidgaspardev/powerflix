abstract class FavoritesRepository {
  Future<bool> isFavorite(String id);
  Future<void> setFavorite(String id, bool value);
}
