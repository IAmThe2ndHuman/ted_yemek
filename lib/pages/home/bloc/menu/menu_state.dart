part of 'menu_cubit.dart';

sealed class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

class MenuInitial extends MenuState {
  const MenuInitial();
}

class MenuLoading extends MenuState {
  const MenuLoading();
}

class MenuLoaded extends MenuState {
  final Menu menu;
  const MenuLoaded(this.menu);

  @override
  List<Object> get props => [menu];

  @override
  String toString() {
    return menu.toString();
  }
}

class MenuError extends MenuState {
  final AppError error;
  const MenuError(this.error);

  @override
  List<Object> get props => [error];
}
