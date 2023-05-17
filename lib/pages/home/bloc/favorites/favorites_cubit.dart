import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../repositories/favorites_repository.dart';


part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _favoritesRepository;
  FavoritesCubit(this._favoritesRepository)
      : super(FavoritesInitial(_favoritesRepository.favoriteDishes));

  Future<void> addFavorite(String dishName) async {
    await _favoritesRepository.addFavorite(dishName);
    emit(FavoriteAdded(_favoritesRepository.favoriteDishes, dishName));
  }

  Future<void> removeFavorite(String dishName) async {
    await _favoritesRepository.removeFavorite(dishName);
    emit(FavoriteRemoved(_favoritesRepository.favoriteDishes, dishName));
  }
}
