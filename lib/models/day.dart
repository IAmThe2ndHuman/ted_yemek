class Day {
  final DateTime date;
  final List<String> dishes;

  Duration? durationUntilLunch() {
    final now = DateTime.now();
    // if (kDebugMode) now = DateTime(now.year, now.month, now.day, 12, 9, 50);
    final isMonday = now.weekday == 1;

    final lunchtime = DateTime(now.year, now.month, now.day, 12, isMonday ? 20 : 10);
    if (now.isAfter(lunchtime)) return null;

    return lunchtime.difference(now);
  }

  const Day(this.dishes, this.date);
}
