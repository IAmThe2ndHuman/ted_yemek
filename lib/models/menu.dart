import 'package:html/parser.dart';

import 'day.dart';

class Menu {
  final List<Day> days;

  Day? get today {
    final now = DateTime.now();
    if (now.weekday > 5) return null;
    return days[now.weekday - 1];
  }

  // todo use intl here
  static int monthNameToNumber(String name) {
    switch (name) {
      case "Ocak":
        return 1;
      case "Şubat":
        return 2;
      case "Mart":
        return 3;
      case "Nisan":
        return 4;
      case "Mayıs":
        return 5;
      case "Haziran":
        return 6;
      case "Temmuz":
        return 7;
      case "Ağustos":
        return 8;
      case "Eylül":
        return 9;
      case "Ekim":
        return 10;
      case "Kasım":
        return 11;
      case "Aralık":
        return 12;
      case _:
        throw UnimplementedError("i should add a case for this");
    }
  }

  factory Menu.parseHtml(String html) {
    final document = parse(html);

    final strong = document.getElementsByTagName("strong");
    final mondayDateRaw = strong.first.text.trim().split(" "); // DAY, MONTH (EEEE), YEAR
    final mondayDate =
        DateTime(int.parse(mondayDateRaw[2]), monthNameToNumber(mondayDateRaw[1]), int.parse(mondayDateRaw[0]), 23, 59);

    final days = document.getElementsByTagName("div").first.children;

    List<Day> menu = [];
    int daysIncrement = 0;

    for (final element in days) {
      final dishes = element.getElementsByClassName("tablo").map((e) => e.text.trim());
      menu.add(Day(dishes.toList(), mondayDate.add(Duration(days: daysIncrement))));
      daysIncrement++;
    }

    return Menu(menu);
  }

  Menu(this.days);
}
