part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();

  @override
  List<Object> get props => [];
}

class HomeLoadingMenu extends HomeState {
  const HomeLoadingMenu();

  @override
  List<Object> get props => [];
}

class HomeMenuAcquired extends HomeState {
  final Menu menu;
  const HomeMenuAcquired(this.menu);

  @override
  List<Object> get props => [menu];
}

class HomeError extends HomeState {
  final AppError error;
  const HomeError(this.error);

  @override
  List<Object> get props => [error];
}
