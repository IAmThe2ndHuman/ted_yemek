import 'package:html/parser.dart';
import 'package:intl/intl.dart';

import 'day.dart';

class Menu {
  final List<Day> days;

  Day? get today {
    final now = DateTime.now();
    if (now.weekday > 5) return null;
    return days[now.weekday - 1];
  }

  factory Menu.parseHtml(String html) {
    final document = parse(html);

    final strong = document.getElementsByTagName("strong");
    final mondayDate = DateFormat("d MMMM yyyy EEEE", "tr_TR").parse(strong.first.text.trim());
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
