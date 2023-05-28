import 'package:flutter/material.dart';
import 'package:ted_yemek/pages/home/bloc/menu/menu_cubit.dart';
import 'package:ted_yemek/pages/settings/bloc/settings_cubit.dart';
import 'package:ted_yemek/repositories/menu_repository.dart';
import 'package:ted_yemek/services/notification_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workmanager/workmanager.dart';

class DebugModal extends StatelessWidget {
  final MenuRepository menuRepository;
  final MenuCubit menuCubit;
  final SettingsCubit settingsCubit;

  const DebugModal({super.key, required this.menuRepository, required this.menuCubit, required this.settingsCubit});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(title: const Text("debug"), contentPadding: const EdgeInsets.all(16), children: [
      Text("cache valid: ${menuRepository.menuCacheValid(settingsCubit.state.schoolType)}\n\n"
          "${menuCubit.state}\n\n${settingsCubit.state.toString()}"),
      ElevatedButton(
          onPressed: () {
            menuRepository.clearCache(settingsCubit.state.schoolType);
            Navigator.pop(context);
          },
          child: const FittedBox(child: Text("invalidate cache"))),
      ElevatedButton(
          onPressed: () => launchUrl(MenuRepository.getMenuUri(settingsCubit.state.schoolType),
              mode: LaunchMode.externalApplication),
          child: const FittedBox(child: Text("view raw menu"))),
      ElevatedButton(
          onPressed: () => menuCubit.initializeMenu(settingsCubit.state.schoolType),
          child: const FittedBox(child: Text("rebuild menu"))),
      ElevatedButton(
          onPressed: () => NotificationService.displayFavoritesNotification({"a", "b"}),
          child: const FittedBox(child: Text("send notif"))),
      ElevatedButton(
          onPressed: () => NotificationService.displayErrorNotification(),
          child: const FittedBox(child: Text("send err notif"))),
      ElevatedButton(
          onPressed: () => Workmanager().registerOneOffTask("test", "test"),
          child: const FittedBox(child: Text("register task notif"))),
      TextButton(onPressed: () => Navigator.pop(context), child: const FittedBox(child: Text("OK")))
    ]);
  }
}
