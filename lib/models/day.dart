import 'package:flutter/material.dart';

class Day {
  final DateTime date;
  final List<String> dishes;

  const Day(this.dishes, this.date);

  Duration? durationUntilLunch(TimeOfDay lunchtimeTime) {
    final now = DateTime.now();
    // if (kDebugMode) now = DateTime(now.year, now.month, now.day, 12, 9, 50);
    // final isMonday = now.weekday == 1;

    final lunchtime = DateTime(now.year, now.month, now.day, lunchtimeTime.hour, lunchtimeTime.minute);
    if (now.isAfter(lunchtime)) return null;

    return lunchtime.difference(now);
  }

  @override
  String toString() {
    return "$runtimeType($dishes, $date)";
  }
}
