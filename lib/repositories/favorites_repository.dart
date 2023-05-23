import 'package:shared_preferences/shared_preferences.dart';

class FavoritesRepository {
  static const String _favorites = "data.favorites";

  final SharedPreferences preferences;
  FavoritesRepository(this.preferences);

  // is this necessary
  List<String>? _favoriteDishesCache;

  Future<List<String>> get favoriteDishes async {
    _favoriteDishesCache ??= preferences.getStringList(_favorites) ?? [];
    return _favoriteDishesCache!;
  }

  Future<void> addFavorite(String dishName) async {
    if (_favoriteDishesCache == null) {
      await favoriteDishes;
    }
    _favoriteDishesCache!.add(dishName);
    preferences.setStringList(_favorites, _favoriteDishesCache!);
  }

  Future<void> removeFavorite(String dishName) async {
    if (_favoriteDishesCache == null) {
      await favoriteDishes;
    }
    _favoriteDishesCache!.remove(dishName);
    preferences.setStringList(_favorites, _favoriteDishesCache!);
  }

  Future<void> clearFavorites() async {
    _favoriteDishesCache?.clear();
    preferences.remove(_favorites);
  }
}
