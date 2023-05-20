part of 'favorites_cubit.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesState {
  final List<String> favorites;
  const FavoritesLoaded(this.favorites);

  @override
  List<Object> get props => [favorites];
}

class FavoriteAdded extends FavoritesLoaded {
  final String addedDish;
  const FavoriteAdded(super.favorites, this.addedDish);

  @override
  List<Object> get props => [super.favorites, addedDish];
}

class FavoriteRemoved extends FavoritesLoaded {
  final String removedDish;
  const FavoriteRemoved(super.favorites, this.removedDish);

  @override
  List<Object> get props => [super.favorites, removedDish];
}
