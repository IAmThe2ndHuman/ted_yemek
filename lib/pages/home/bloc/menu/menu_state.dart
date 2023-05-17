part of 'menu_cubit.dart';

abstract class MenuState extends Equatable {
  const MenuState();
}

class MenuInitial extends MenuState {
  const MenuInitial();

  @override
  List<Object> get props => [];
}

class LoadingMenu extends MenuState {
  const LoadingMenu();

  @override
  List<Object> get props => [];
}

class MenuAcquired extends MenuState {
  final Menu menu;
  const MenuAcquired(this.menu);

  @override
  List<Object> get props => [menu];
}

class MenuError extends MenuState {
  final AppError error;
  const MenuError(this.error);

  @override
  List<Object> get props => [error];
}
