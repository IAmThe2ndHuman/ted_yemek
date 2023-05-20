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
      final day = Menu.parseHtml(await menuRepo.getMenuHtml()).days[inputData!["weekdayIndex"]];
      final favorites = await favoritesRepo.favoriteDishes;

      final intersection = day.dishes.toSet().intersection(favorites.toSet());
      if (intersection.isNotEmpty) {
        await NotificationService.displayFavoritesNotification(intersection);
      }
    } catch (e) {
      await NotificationService.displayErrorNotification();
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

  // WAS TIRED WHEN I WROTE THIS
  static Future<void> scheduleWeeklyFavoriteNotificationTasks(Menu menu, TimeOfDay time) async {
    final now = DateTime.now();

    for (final day in menu.days) {
      final dateOfNotifying = DateTime(day.date.year, day.date.month, day.date.day, time.hour, time.minute);

      await Workmanager().registerPeriodicTask(
          "weekly-favorite-notification-${day.date.hashCode}", "weeklyFavoriteNotification",
          tag: "weekly-favorite-notification-${day.date.hashCode}",
          backoffPolicyDelay: const Duration(minutes: 30),
          backoffPolicy: BackoffPolicy.linear,
          inputData: {"weekdayIndex": day.date.weekday - 1},
          initialDelay: now.isAfter(dateOfNotifying)
              ? dateOfNotifying.add(const Duration(days: 7)).difference(now)
              : dateOfNotifying.difference(now),
          frequency: const Duration(days: 7));
    }
  }

  // static Future<void> scheduleWeeklyMenuRefresh(TimeOfDay time) async {
  //   final now = DateTime.now();
  //   final nextWeekMonday3am = DateTime(now.year, now.month, now.day, 3)
  //       .add(Duration(days: 8 - now.weekday)); // 3am just to ensure the new menu is actually updated
  //   // todo manual reschedule task for ios
  //
  //   // await _workManager.registerPeriodicTask("update-menu-identifier", "updateMenu",
  //   //     backoffPolicyDelay: const Duration(minutes: 30),
  //   //     backoffPolicy: BackoffPolicy.linear,
  //   //     initialDelay: nextWeekMonday3am.difference(now),
  //   //     inputData: {"h": time.hour, "m": time.minute},
  //   //     frequency: const Duration(days: 7));  // todo real one
  //
  //   /* todo ok it would be WAY WAY EASier if i just did thi:
  //     create one task for each day and send notification at that time instead of scheduling a notification
  //     ahead of time
  //
  //     every day at the specified time, compare favorites and current menu
  //     if Set<T> of intersection length > 0, send a notification. otherwise dont do ANYTHING
  //
  //     if no internet, send notification
  //    */
  //
  //   await Workmanager().registerPeriodicTask("update-menu-identifier", "updateMenu",
  //       backoffPolicyDelay: const Duration(minutes: 30),
  //       backoffPolicy: BackoffPolicy.linear,
  //       inputData: {"h": time.hour, "m": time.minute},
  //       frequency: const Duration(minutes: 1));
  //   await Future.delayed(Duration(seconds: 1));
  //   await Workmanager().registerPeriodicTask("update-menu-identifier-2", "updateMenu2",
  //       backoffPolicyDelay: const Duration(minutes: 30),
  //       backoffPolicy: BackoffPolicy.linear,
  //       inputData: {"h": time.hour, "m": time.minute},
  //       frequency: const Duration(minutes: 1));
  // }
}
