import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../models/menu.dart';
import '../repositories/favorites_repository.dart';
import '../repositories/menu_repository.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
void _callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final preferences = await SharedPreferences.getInstance();

    final menuRepo = MenuRepository(preferences);
    final favoritesRepo = FavoritesRepository(preferences);
    final now = DateTime.now();

    HttpOverrides.global = MyHttpOverrides(); // todo remove later

    try {
      await initializeDateFormatting("tr_TR");
      final day = Menu.fromHtml(await menuRepo.getMenuHtml()).days[now.weekday - 1];
      final favorites = await favoritesRepo.favoriteDishes;

      final intersection = day.dishes.toSet().intersection(favorites.toSet());
      if (intersection.isNotEmpty) {
        await NotificationService.displayFavoritesNotification(intersection);
      }
    } catch (e) {
      await NotificationService.displayErrorNotification(e);
    }
    return true;
  });
}

class TimeOfReminder extends Equatable {
  final TimeOfDay? timeOfDay;
  final bool sawReminderDialog;

  const TimeOfReminder({required this.timeOfDay, required this.sawReminderDialog});

  @override
  List<Object?> get props => [timeOfDay, sawReminderDialog];
}

sealed class IsolateService {
  static const _remindersEnabledSawDialog = "data.remindersEnabled.sawDialog";
  static const _remindersEnabledHour = "data.remindersEnabled.h";
  static const _remindersEnabledMinute = "data.remindersEnabled.m";

  static Future<void> initialize() async {
    await Workmanager().initialize(_callbackDispatcher, isInDebugMode: kDebugMode);
  }

  static Future<TimeOfReminder> get timeOfReminder async {
    final prefs = await SharedPreferences.getInstance();

    final hour = prefs.getInt(_remindersEnabledHour);
    final minute = prefs.getInt(_remindersEnabledMinute);
    final sawDialog = prefs.getBool(_remindersEnabledSawDialog) ?? false;

    TimeOfDay? timeOfDay;
    if (hour != null && minute != null) {
      timeOfDay = TimeOfDay(hour: hour, minute: minute);
    }
    return TimeOfReminder(timeOfDay: timeOfDay, sawReminderDialog: sawDialog);
  }

  static Future<void> cancelAll({bool edit = false}) async {
    await Workmanager().cancelAll();

    if (!edit) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_remindersEnabledHour);
      await prefs.remove(_remindersEnabledMinute);
    }
  }

  // WAS TIRED WHEN I WROTE THIS
  static Future<void> scheduleReminders(Menu menu, TimeOfDay time) async {
    final now = DateTime.now();

    for (final day in menu.days) {
      final dateOfNotifying = DateTime(day.date.year, day.date.month, day.date.day, time.hour, time.minute);

      await Workmanager().registerPeriodicTask(
          "weekly-favorite-notification-${day.date.hashCode}", "weeklyFavoriteNotification",
          tag: "weekly-favorite-notification-${day.date.hashCode}",
          backoffPolicyDelay: const Duration(minutes: 30),
          backoffPolicy: BackoffPolicy.linear,
          // inputData: {"weekdayIndex": day.date.weekday - 1},
          initialDelay: now.isAfter(dateOfNotifying)
              ? dateOfNotifying.add(const Duration(days: 7)).difference(now)
              : dateOfNotifying.difference(now),
          frequency: const Duration(days: 7));
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_remindersEnabledSawDialog, true);
    await prefs.setInt(_remindersEnabledHour, time.hour);
    await prefs.setInt(_remindersEnabledMinute, time.minute);
  }
}
