import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ted_yemek/pages/home/bloc/favorites/favorites_cubit.dart';
import 'package:ted_yemek/pages/home/views/favorites_view.dart';
import 'package:ted_yemek/repositories/favorites_repository.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../repositories/menu_repository.dart';
import 'bloc/menu/menu_cubit.dart';
import 'views/error_view.dart';
import 'views/menu_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AfterLayoutMixin {
  int _view = 0;

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    await context.read<MenuCubit>().initializeMenu();
  }

  Future<void> _showDebugDialog() async {
    var cacheValid = await context.read<MenuRepository>().menuCacheValid;
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
                      child: const FittedBox(
                          child: Text("MenuRepository.clearCache()"))),
                  ElevatedButton(
                      onPressed: () => launchUrl(MenuRepository.menuUri,
                          mode: LaunchMode.externalApplication),
                      child: const FittedBox(
                          child: Text(
                              "launchUrl(MenuRepository.menuUri, mode: LaunchMode.externalApplication)"))),
                  ElevatedButton(
                      onPressed: this.context.read<MenuCubit>().initializeMenu,
                      child: const FittedBox(
                          child: Text(
                              "context.read<HomeCubit>().initializeMenu()"))),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"))
              ],
            );
          });
    }
  }

  Future<void> _showAboutDialog() async {
    var pkgInfo = await PackageInfo.fromPlatform();

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
                  Text("YAZILIMCI",
                      style: Theme.of(context).textTheme.labelSmall),
                  const Text("Koray Öztürkler"),
                  const SizedBox(height: 10),
                  Text("SÜRÜM", style: Theme.of(context).textTheme.labelSmall),
                  Text("v${pkgInfo.version}"),
                  const SizedBox(height: 10),
                  Text("SDK SÜRÜMÜ",
                      style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/flutter.svg",
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.onSurface,
                            BlendMode.srcIn),
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
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("TAMAM"))
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
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("HAYIR"))
            ],
          );
        });
  }

  Widget _viewBuilder() {
    return [
      BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          if (state is MenuInitial) {
            return Container();
          } else if (state is LoadingMenu) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MenuAcquired) {
            return MenuView(menu: state.menu);
          } else if (state is MenuError) {
            return ErrorView(error: state.error);
          } else {
            return Container();
          }
        },
      ),
      BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) => FavoritesView(favorites: state.favorites),
      ),
    ][_view];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TED Yemek Menüsü"),
        actions: [
          IconButton(
              onPressed: _showAboutDialog,
              icon: const Icon(Icons.info_outline)),
        ],
      ),
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: ((child, primaryAnimation, secondaryAnimation) =>
            FadeThroughTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              fillColor: Theme.of(context).colorScheme.surface,
              child: child,
            )),
        child: _viewBuilder(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _view,
        onDestinationSelected: (view) => setState(() => _view = view),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: "Menü",
          ),
          NavigationDestination(
              icon: Icon(Icons.favorite_border),
              selectedIcon: Icon(Icons.favorite),
              label: "Favoriler"),
        ],
      ),
      floatingActionButton: _view == 1
          ? FloatingActionButton(
              child: const Icon(Icons.delete_forever),
              onPressed: _showClearFavoritesDialog,
            )
          : null,
    );
  }
}
