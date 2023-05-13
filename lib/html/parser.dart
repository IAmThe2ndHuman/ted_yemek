import 'package:html/parser.dart' show parse;

import 'day.dart';

class HtmlParser {
  static Menu toMenu(String html) {
    var document = parse(html);

    var strong = document.getElementsByTagName("strong");
    var mondayDate = strong.first.text.trim();

    var days = document.getElementsByTagName("div").first.children.asMap();

    List<Day> menu = [];
    days.forEach((key, value) {
      var dishes = value.getElementsByClassName("tablo").map((e) => e.text.trim());
      menu.add(Day(dishes.toList(), key + 1));
    });

    return Menu(menu, mondayDate);
  }
}

class Menu {
  final List<Day> days;
  final String mondayDate;

  Day? get today {
    var now = DateTime.now();
    if (now.weekday > 5) return null;
    return days[now.weekday - 1];
  }

  Menu(this.days, this.mondayDate);
}
