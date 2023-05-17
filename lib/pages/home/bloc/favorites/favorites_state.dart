part of 'favorites_cubit.dart';

sealed class FavoritesState extends Equatable {
  final Future<List<String>> favorites;
  const FavoritesState(this.favorites);
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial(super.favorites);

  @override
  List<Object> get props => [super.favorites];
}

class FavoriteAdded extends FavoritesState {
  final String addedDish;
  const FavoriteAdded(super.favorites, this.addedDish);

  @override
  List<Object> get props => [super.favorites, addedDish];
}

class FavoriteRemoved extends FavoritesState {
  final String removedDish;
  const FavoriteRemoved(super.favorites, this.removedDish);

  @override
  List<Object> get props => [super.favorites, removedDish];
}
