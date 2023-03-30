import 'day.dart';

import 'package:html/parser.dart' show parse;

class HtmlParser {
  static List<Day> toMenu(String html) {
    var document = parse(html);
    var days = document.getElementsByTagName("div")[2].children.asMap();

    List<Day> menu = [];
    days.forEach((key, value) {
      var dishes = value.getElementsByClassName("tablo").map((e) => e.text);
      menu.add(Day(dishes.toList(), key + 1));
    });

    return menu;
  }
}