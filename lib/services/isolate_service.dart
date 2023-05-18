import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import '../models/menu.dart';
import '../repositories/favorites_repository.dart';
import '../repositories/menu_repository.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
void _callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final menuRepo = MenuRepository();
    final favoritesRepo = FavoritesRepository();

    NotificationService.initialize();

    try {
      final menu = Menu.parseHtml(await menuRepo.getMenuHtml());
      await NotificationService.scheduleWeeklyFavoriteNotifications(
          menu, await favoritesRepo.favoriteDishes, TimeOfDay(hour: inputData!["h"], minute: inputData["m"]), false);
    } catch (e) {
      return false;
    }

    return true;
  });
}

sealed class IsolateService {
  static Future<void> initialize() async {
    await Workmanager().initialize(_callbackDispatcher, isInDebugMode: kDebugMode);
  }

  static Future<void> cancelAll() async {
    await Workmanager().cancelAll();
  }

  static Future<void> scheduleWeeklyMenuRefresh(TimeOfDay time) async {
    final now = DateTime.now();
    final nextWeekMonday3am = DateTime(now.year, now.month, now.day, 3)
        .add(Duration(days: 8 - now.weekday)); // 3am just to ensure the new menu is actually updated
    // todo manual reschedule task for ios

    // await _workManager.registerPeriodicTask("update-menu-identifier", "updateMenu",
    //     backoffPolicyDelay: const Duration(minutes: 30),
    //     backoffPolicy: BackoffPolicy.linear,
    //     initialDelay: nextWeekMonday3am.difference(now),
    //     inputData: {"h": time.hour, "m": time.minute},
    //     frequency: const Duration(days: 7));  // todo real one

    /* todo ok it would be WAY WAY EASier if i just did thi:
      create one task for each day and send notification at that time instead of scheduling a notification
      ahead of time

      every day at the specified time, compare favorites and current menu
      if Set<T> of intersection length > 0, send a notification. otherwise dont do ANYTHING

      if no internet, send notification
     */

    await Workmanager().registerPeriodicTask("update-menu-identifier", "updateMenu",
        backoffPolicyDelay: const Duration(minutes: 30),
        backoffPolicy: BackoffPolicy.linear,
        inputData: {"h": time.hour, "m": time.minute},
        frequency: const Duration(minutes: 1));
    await Future.delayed(Duration(seconds: 1));
    await Workmanager().registerPeriodicTask("update-menu-identifier-2", "updateMenu2",
        backoffPolicyDelay: const Duration(minutes: 30),
        backoffPolicy: BackoffPolicy.linear,
        inputData: {"h": time.hour, "m": time.minute},
        frequency: const Duration(minutes: 1));
  }
}
