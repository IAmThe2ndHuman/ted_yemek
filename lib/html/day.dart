class Day {
  final int dayNumber;
  final List<String> dishes;

  String get dayOfTheWeek {
    switch (dayNumber) {
      case 1:
        return "Pazartesi";
      case 2:
        return "Salı";
      case 3:
        return "Çarşamba";
      case 4:
        return "Perşembe";
      case 5:
        return "Cuma";
      default:
        return "???";
    }
  }

  Duration? durationUntilLunch() {
    var now = DateTime.now();
    // if (kDebugMode) now = DateTime(now.year, now.month, now.day, 12, 9, 50);
    var isMonday = now.weekday == 1;

    var lunchtime = DateTime(now.year, now.month, now.day, 12, isMonday ? 20 : 10);
    if (now.isAfter(lunchtime)) return null;

    return lunchtime.difference(now);
  }

  Day(this.dishes, this.dayNumber);

  @override
  String toString() {
    return "$dayNumber ($dayOfTheWeek) : $dishes";
  }
}
