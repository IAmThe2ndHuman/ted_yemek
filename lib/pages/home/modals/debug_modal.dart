import 'package:flutter/material.dart';
import 'package:ted_yemek/pages/home/bloc/menu/menu_cubit.dart';
import 'package:ted_yemek/repositories/menu_repository.dart';
import 'package:ted_yemek/services/notification_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workmanager/workmanager.dart';

class DebugModal extends StatelessWidget {
  final MenuRepository menuRepository;
  final MenuCubit menuCubit;

  const DebugModal(
      {super.key, required this.menuRepository, required this.menuCubit});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("debug"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
              onPressed: () async => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          (await menuRepository.menuCacheValid).toString()))),
              child: const FittedBox(child: Text("check cache state"))),
          ElevatedButton(
              onPressed: menuRepository.clearCache,
              child: const FittedBox(child: Text("invalidate cache"))),
          ElevatedButton(
              onPressed: () => launchUrl(MenuRepository.menuUri,
                  mode: LaunchMode.externalApplication),
              child: const FittedBox(child: Text("view raw menu"))),
          ElevatedButton(
              onPressed: menuCubit.initializeMenu,
              child: const FittedBox(child: Text("rebuild menu"))),
          ElevatedButton(
              onPressed: () =>
                  NotificationService.displayFavoritesNotification({"a", "b"}),
              child: const FittedBox(child: Text("send notif"))),
          ElevatedButton(
              onPressed: () => NotificationService.displayErrorNotification(),
              child: const FittedBox(child: Text("send err notif"))),
          ElevatedButton(
              onPressed: () => Workmanager().registerOneOffTask("test", "test"),
              child: const FittedBox(child: Text("register task notif"))),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text("OK"))
      ],
    );
  }
}
