import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@pragma("vm:entry-point")
Future<void> _onActionReceivedMethod(ReceivedAction receivedAction) async {}

sealed class NotificationService {
  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Günlük menü bildirimleri',
            channelDescription: null,
          )
        ],
        debug: kDebugMode);
  }

  static Future<void> setListeners() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: _onActionReceivedMethod);
  }

  static Future<bool> requestNotificationAccess() async {
    if (!await AwesomeNotifications().isNotificationAllowed()) {
      return await AwesomeNotifications()
          .requestPermissionToSendNotifications();
    }
    return true;
  }

  static Future<void> displayFavoritesNotification(
      Set<String> intersection) async {
    final random = Random();
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            icon: "resource://drawable/res_app_icon",
            backgroundColor: Colors.blue,
            id: random.nextInt(100),
            channelKey: 'basic_channel',
            title: 'Bugün beğendiğiniz ${intersection.length} çeşit yemek var',
            body: intersection.join(", ")));
  }

  static Future<void> displayErrorNotification([Object? e]) async {
    final random = Random();
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            icon: "resource://drawable/res_app_icon",
            backgroundColor: Colors.red,
            id: random.nextInt(100),
            channelKey: 'basic_channel',
            title: 'Menüye ulaşılamadı',
            body: kDebugMode && e != null
                ? e.toString()
                : 'Lütfen internet bağlantınızı kontrol edin.'));
  }

  // static Future<void> scheduleWeeklyFavoriteNotifications(Menu menu, List<String> favorites, TimeOfDay time,
  //     [bool scheduleTask = true]) async {
  //   final random = Random();
  //   final now = DateTime.now();
  //
  //   List<(DateTime, Set<String>)> favoriteIntersection = []; // (date of notification, contents)
  //
  //   for (var day in menu.days) {
  //     var intersection = day.dishes.toSet().intersection(favorites.toSet());
  //     if (intersection.isNotEmpty && now.isBefore(day.date)) favoriteIntersection.add((day.date, intersection));
  //   }
  //
  //   for (var intersection in favoriteIntersection) {
  //     await AwesomeNotifications().createNotification(
  //         schedule: NotificationCalendar(
  //             timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier(),
  //             year: intersection.$1.year,
  //             month: intersection.$1.month,
  //             day: intersection.$1.day,
  //             hour: time.hour,
  //             minute: time.minute,
  //             allowWhileIdle: true),
  //         content: NotificationContent(
  //             id: random.nextInt(100),
  //             channelKey: 'basic_channel',
  //             title: 'Bugün yemekte olacak (placeholder)',
  //             body: intersection.$2.join(", ")));
  //   }
  //
  //   if (scheduleTask && favoriteIntersection.isNotEmpty) {
  //     IsolateService.scheduleWeeklyMenuRefresh(time);
  //   }
  // }
}
