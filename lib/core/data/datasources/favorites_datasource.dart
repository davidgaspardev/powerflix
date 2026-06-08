abstract class FavoritesDatasource {
  Future<bool> isFavorite(String id);
  Future<void> setFavorite(String id, bool value);
}
