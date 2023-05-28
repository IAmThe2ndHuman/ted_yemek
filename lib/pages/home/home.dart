import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ted_yemek/constants.dart';
import 'package:ted_yemek/pages/home/modals/debug_modal.dart';
import 'package:ted_yemek/pages/settings/bloc/settings_cubit.dart';

import '../../repositories/menu_repository.dart';
import '../settings/settings.dart';
import 'bloc/favorites/favorites_cubit.dart';
import 'bloc/menu/menu_cubit.dart';
import 'bloc/reminder/reminder_cubit.dart';
import 'components/reminder_icon_button.dart';
import 'views/error_view.dart';
import 'views/favorites_view.dart';
import 'views/menu_view.dart';

class Home extends StatefulWidget {
  static const String routeName = "/";
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _viewIndex = 0;
  bool _showFab = false;

  final List<Widget> _views = [
    BlocBuilder<MenuCubit, MenuState>(
      builder: (context, state) {
        if (state is MenuInitial) {
          return Container();
        } else if (state is MenuLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MenuLoaded) {
          return MenuView(menu: state.menu);
        } else if (state is MenuError) {
          return ErrorView(error: state.error);
        } else {
          return Container();
        }
      },
    ),
    BlocBuilder<FavoritesCubit, FavoritesState>(
      // todo integrate into the view itself...or not idk
      builder: (context, state) {
        if (state is FavoritesInitial) {
          return Container();
        } else if (state is FavoritesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FavoritesLoaded) {
          return FavoritesView(favorites: state.favorites);
        } else {
          return Container();
        }
      },
    ),
  ];

  @override
  void initState() {
    super.initState();
    context.read<MenuCubit>().initializeMenu(context.read<SettingsCubit>().state.schoolType);
    context.read<FavoritesCubit>().initializeFavorites();
    context.read<ReminderCubit>().initializeReminder();
  }

  // @override
  // FutureOr<void> afterFirstLayout(BuildContext context) async {
  //   context.read<MenuCubit>().initializeMenu();
  //   context.read<FavoritesCubit>().initializeFavorites();
  //   context.read<ReminderCubit>().initializeReminder();
  // }

  void _showDebugDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return DebugModal(
            menuRepository: this.context.read<MenuRepository>(),
            menuCubit: this.context.read<MenuCubit>(),
            settingsCubit: this.context.read<SettingsCubit>(),
          );
        });
  }

  void _showClearFavoritesDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Favori Silme"),
            content: const Text("Tüm favorilerinizi silmek istiyor musunuz?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    this.context.read<FavoritesCubit>().clearFavorites();
                  },
                  child: const Text("EVET, SİL")),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("HAYIR"))
            ],
          );
        });
  }

  void _toggleFab(FavoritesState state) {
    setState(() {
      _showFab = state is FavoritesLoaded && (state.favorites).isNotEmpty && _viewIndex == 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // FOR FAB
        BlocListener<FavoritesCubit, FavoritesState>(
          listener: (context, state) => _toggleFab(state),
        ),
        BlocListener<SettingsCubit, SettingsState>(
          listener: (context, state) => context.read<MenuCubit>().initializeMenu(state.schoolType),
          listenWhen: (prev, current) => prev.schoolType != current.schoolType,
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          title: GestureDetector(onLongPress: _showDebugDialog, child: const Text(appName)),
          actions: [
            IgnorePointer(
              // fight me
              ignoring: _viewIndex != 1,
              child: AnimatedOpacity(
                opacity: _viewIndex == 1 ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: const ReminderIconButton(), // gotta keep it const somehow eh
              ),
            ),
            IconButton(
                onPressed: () => Navigator.pushNamed(context, Settings.routeName),
                icon: const Icon(Icons.settings_outlined)),
          ],
        ),
        body: PageTransitionSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: ((child, primaryAnimation, secondaryAnimation) => FadeThroughTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  fillColor: Theme.of(context).colorScheme.surface,
                  child: child,
                )),
            child: _views[_viewIndex]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _viewIndex,
          onDestinationSelected: (view) {
            _viewIndex = view;
            _toggleFab(context.read<FavoritesCubit>().state);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.restaurant_menu_outlined),
              selectedIcon: Icon(Icons.restaurant_menu),
              label: "Menü",
            ),
            NavigationDestination(
                icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: "Favoriler"),
          ],
        ),
        floatingActionButton: _showFab
            ? FloatingActionButton(
                onPressed: _showClearFavoritesDialog,
                child: const Icon(Icons.delete_forever),
              )
            : null,
      ),
    );
  }
}
