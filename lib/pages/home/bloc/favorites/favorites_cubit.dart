import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../repositories/favorites_repository.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _favoritesRepository;
  FavoritesCubit(this._favoritesRepository) : super(const FavoritesInitial());

  Future<void> addFavorite(String dishName) async {
    await _favoritesRepository.addFavorite(dishName);
    emit(FavoriteAdded(await _favoritesRepository.favoriteDishes, dishName));
  }

  Future<void> removeFavorite(String dishName) async {
    await _favoritesRepository.removeFavorite(dishName);
    emit(FavoriteRemoved(await _favoritesRepository.favoriteDishes, dishName));
  }

  Future<void> initializeFavorites() async {
    emit(const FavoritesLoading());
    emit(FavoritesLoaded(await _favoritesRepository.favoriteDishes));
  }

  Future<void> clearFavorites() async {
    await _favoritesRepository.clearFavorites();
    emit(FavoritesLoaded(await _favoritesRepository.favoriteDishes));
  }
}
