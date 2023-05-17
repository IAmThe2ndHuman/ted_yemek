import 'package:shared_preferences/shared_preferences.dart';

// perhaps i ought to make a separate class that manages sharedprefrences lol
// TODO: profile app to check if calling SharedPreferences.getInstance every time is bad
// the reason i doubt this is true is because the source of SharedPreferences.getInstance clearly states that it uses
// a sort of 'singleton' to avoid pulling the instance every time

class FavoritesRepository {
  static const String _favorites = "data.favorites";

  // ok this is jUST a precaution, also to make readability better
  // if sharedpreferences doesnt use a singleton then this means there are 2 sharedprefs in my app (bad)
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // is this necessary
  List<String>? _favoriteDishesCache;

  Future<List<String>> get favoriteDishes async {
    _favoriteDishesCache ??= (await _prefs).getStringList(_favorites) ?? [];
    return _favoriteDishesCache!;
  }

  Future<void> addFavorite(String dishName) async {
    if (_favoriteDishesCache == null) {
      await favoriteDishes;
    }
    _favoriteDishesCache!.add(dishName);
    (await _prefs).setStringList(_favorites, _favoriteDishesCache!);
  }

  Future<void> removeFavorite(String dishName) async {
    if (_favoriteDishesCache == null) {
      await favoriteDishes;
    }
    _favoriteDishesCache!.remove(dishName);
    (await _prefs).setStringList(_favorites, _favoriteDishesCache!);
  }

  Future<void> clearFavorites() async {
    _favoriteDishesCache?.clear();
    (await _prefs).remove(_favorites);
  }
}
