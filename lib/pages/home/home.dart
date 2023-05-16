import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../repositories/menu_repository.dart';
import 'bloc/home_cubit.dart';
import 'views/error_view.dart';
import 'views/menu_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AfterLayoutMixin {
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    await BlocProvider.of<HomeCubit>(context).initializeMenu();
  }

  Future<void> _showDebugDialog() async {
    var cacheValid = await MenuRepository.menuCacheValid;
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
                  const ElevatedButton(
                      onPressed: MenuRepository.clearCache,
                      child: FittedBox(
                          child: Text("MenuRepository.clearCache()"))),
                  ElevatedButton(
                      onPressed: () => launchUrl(MenuRepository.menuUri,
                          mode: LaunchMode.externalApplication),
                      child: const FittedBox(
                          child: Text(
                              "launchUrl(MenuRepository.menuUri, mode: LaunchMode.externalApplication)"))),
                  ElevatedButton(
                      onPressed: BlocProvider.of<HomeCubit>(this.context)
                          .initializeMenu,
                      child: const FittedBox(
                          child: Text(
                              "BlocProvider.of<HomeCubit>(context).initializeMenu()"))),
                  const ElevatedButton(
                      onPressed: SystemNavigator.pop,
                      child: Text("Kill process")),
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
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeInitial) {
            return Container();
          } else if (state is HomeLoadingMenu) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeMenuAcquired) {
            return MenuView(menu: state.menu);
          } else if (state is HomeError) {
            return ErrorView(error: state.error);
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: const FloatingActionButton.extended(
        icon: Icon(Icons.favorite),
        label: Text("Favoriler"),
        onPressed: null,
      ),
    );
  }
}
