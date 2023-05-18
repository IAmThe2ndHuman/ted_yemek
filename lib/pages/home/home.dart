import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ted_yemek/services/isolate_service.dart';
import 'package:ted_yemek/services/notification_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../repositories/menu_repository.dart';
import 'bloc/favorites/favorites_cubit.dart';
import 'bloc/menu/menu_cubit.dart';
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
  ];

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    await context.read<MenuCubit>().initializeMenu();
  }

  Future<void> _showDebugDialog() async {
    final registeredNotifications = await NotificationService.listScheduledWeeklyFavoriteNotifications();
    if (!mounted) return;
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
                  Text(
                      registeredNotifications.map((e) => "'${e.content?.body}' AT ${e.schedule?.timeZone}").join("\n")),
                  ElevatedButton(
                      onPressed: this.context.read<MenuRepository>().clearCache,
                      child: const FittedBox(child: Text("invalidate cache"))),
                  ElevatedButton(
                      onPressed: () => launchUrl(MenuRepository.menuUri, mode: LaunchMode.externalApplication),
                      child: const FittedBox(child: Text("view raw menu"))),
                  ElevatedButton(
                      onPressed: this.context.read<MenuCubit>().initializeMenu,
                      child: const FittedBox(child: Text("rebuild menu"))),
                  const ElevatedButton(
                      onPressed: NotificationService.cancelWeeklyFavoriteNotifications,
                      child: FittedBox(child: Text("cancel scheduled notifications"))),
                  const ElevatedButton(
                      onPressed: IsolateService.cancelAll, child: FittedBox(child: Text("cancel isolate"))),
                ],
              ),
              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
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
    _showFab = (await state.favorites).isNotEmpty && _viewIndex == 1;
    setState(() {});
  }

  Future<void> _testNotificationPicker() async {
    var menuState = context.read<MenuCubit>().state;
    var favorites = await context.read<FavoritesCubit>().state.favorites;

    if (!mounted) return;
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Reminders"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("This feature will remind you if a dish you like is available on a certain day."),
                  Card(
                    margin: const EdgeInsets.only(top: 10),
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: const ListTile(
                      leading: Icon(Icons.info_outline),
                      subtitle: Text("You will not be able to edit your favorites while this is on."),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.only(top: 10),
                    elevation: 0,
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: const ListTile(
                      leading: Icon(Icons.warning_amber),
                      subtitle: Text(
                          "This feature is experimental and may not work all the time. In fact, it will probably break."),
                    ),
                  ),
                ],
              ),
              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
            ));
    if (await NotificationService.requestNotificationAccess() && menuState is MenuAcquired) {
      if (!mounted) return;
      final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (time != null) {
        if ((time.hour <= 4 || time.hour > 22) && mounted) {
          await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("Reminders"),
                    content: const Text("Please pick a time between 05:00 and 23:00."),
                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
                  ));
        } else {
          NotificationService.scheduleWeeklyFavoriteNotifications(menuState.menu, favorites, time);
        }
      }
    }
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
            if (_viewIndex == 1)
              IconButton(onPressed: _testNotificationPicker, icon: Icon(Icons.notification_add_outlined)),
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
