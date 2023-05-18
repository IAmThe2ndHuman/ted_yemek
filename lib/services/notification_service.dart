import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';

sealed class NotificationService {
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {}

  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
          )
        ],
        debug: true);
  }

  static Future<void> setListeners() async {
    AwesomeNotifications().setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  static Future<bool> requestNotificationAccess() async {
    if (!await AwesomeNotifications().isNotificationAllowed()) {
      return await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    return true;
  }

  static Future<void> cancelWeeklyFavoriteNotifications() async {
    await AwesomeNotifications().cancelAllSchedules();
  }

  static Future<List<NotificationModel>> listScheduledWeeklyFavoriteNotifications() async {
    return await AwesomeNotifications().listScheduledNotifications();
  }

  static Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancelSchedule(id);
  }

  static Future<void> displayFavoritesNotification(Set<String> intersection) async {
    final random = Random();
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: random.nextInt(100),
            channelKey: 'basic_channel',
            title: 'Bugün yemekte olacak (placeholder)',
            body: intersection.join(", ")));
  }

  static Future<void> displayErrorNotification() async {
    final random = Random();
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: random.nextInt(100),
            channelKey: 'basic_channel',
            title: 'Hata',
            body: 'Yemek listesi alınamadı. Lütfen internet bağlantınızı kontrol edin.'));
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
