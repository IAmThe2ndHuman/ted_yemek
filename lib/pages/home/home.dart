import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../repositories/menu_repository.dart';
import 'bloc/favorites/favorites_cubit.dart';
import 'bloc/menu/menu_cubit.dart';
import 'bloc/reminder/reminder_cubit.dart';
import 'components/reminder_icon_button.dart';
import 'views/error_view.dart';
import 'views/favorites_view.dart';
import 'views/menu_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AfterLayoutMixin {
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
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    context.read<MenuCubit>().initializeMenu();
    context.read<FavoritesCubit>().initializeFavorites();
    context.read<ReminderCubit>().initializeReminder();
  }

  Future<void> _showDebugDialog() async {
    final cacheValid = await context.read<MenuRepository>().menuCacheValid;

    if (mounted) {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Debug Menu"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("menuCacheValid: $cacheValid"),
                  ElevatedButton(
                      onPressed: this.context.read<MenuRepository>().clearCache,
                      child: const FittedBox(child: Text("invalidate cache"))),
                  ElevatedButton(
                      onPressed: () => launchUrl(MenuRepository.menuUri, mode: LaunchMode.externalApplication),
                      child: const FittedBox(child: Text("view raw menu"))),
                  ElevatedButton(
                      onPressed: this.context.read<MenuCubit>().initializeMenu,
                      child: const FittedBox(child: Text("rebuild menu"))),
                  ElevatedButton(
                      onPressed: this.context.read<ReminderCubit>().disableReminder,
                      child: const FittedBox(child: Text("cancel all tasks"))),
                  ElevatedButton(
                      onPressed: () => setState(() => SharedPreferences.getInstance()
                          .then((value) => value.remove("data.remindersEnabled.sawDialog"))),
                      child: const FittedBox(child: Text("reset data.remindersEnabled.sawDialog"))),
                ],
              ),
              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
            );
          });
    }
  }

  Future<void> _showAboutDialog() async {
    final pkgInfo = await PackageInfo.fromPlatform();

    if (mounted) {
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Hakkında"),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("YAZILIMCI", style: Theme.of(context).textTheme.labelSmall),
                  const Text("Koray Öztürkler"),
                  const SizedBox(height: 10),
                  Text("SÜRÜM", style: Theme.of(context).textTheme.labelSmall),
                  Text("v${pkgInfo.version}"),
                  const SizedBox(height: 10),
                  Text("SDK SÜRÜMÜ", style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/flutter.svg",
                        colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSurface, BlendMode.srcIn),
                        height: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "v3.7.0",
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showDebugDialog();
                    },
                    child: const Text("DEBUG")),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("TAMAM"))
              ],
            );
          });
    }
  }

  void _showClearFavoritesDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Tüm favorilerini silme"),
            content: const Text("Tüm favorilerinizi silmek ister misiniz?"),
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

  Future<void> _toggleFab(FavoritesState state) async {
    _showFab = state is FavoritesLoaded && (state.favorites).isNotEmpty && _viewIndex == 1;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesCubit, FavoritesState>(
      // FOR FAB
      listener: (context, state) => _toggleFab(state),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("TED Yemek Menüsü"),
          actions: [
            if (_viewIndex == 1) const ReminderIconButton(),
            IconButton(onPressed: _showAboutDialog, icon: const Icon(Icons.info_outline)),
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
