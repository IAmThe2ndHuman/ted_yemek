import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:ted_yemek/models/error.dart';
import 'package:ted_yemek/repositories/settings_repository.dart';
import 'package:url_launcher/url_launcher.dart';

import '../repositories/menu_repository.dart';
import 'day.dart';

class Menu {
  final List<Day> days;

  const Menu(this.days);

  // static List<Dishes> dishesFromHtml(String html) {}

  Day? get today {
    final now = DateTime.now();
    if (now.weekday > 5) return null;
    return days[now.weekday - 1];
  }

  factory Menu.fromHtml(String html, SchoolType schoolType) {
    try {
      final document = parse(html);

      final strong = document.getElementsByTagName("strong");
      final mondayDate = DateFormat("d MMMM yyyy EEEE", "tr_TR").parse(strong.first.text.trim());

      // two cases identified so far
      final divs = document.getElementsByTagName("div");
      final days = (divs.length == 1 ? divs.first : divs[2]).children;

      List<Day> menu = [];
      int daysIncrement = 0;

      for (final element in days) {
        final dishes = element.getElementsByClassName("tablo").map((e) => e.text.trim());
        menu.add(Day(dishes.toList(), mondayDate.add(Duration(days: daysIncrement))));
        daysIncrement++;
      }

      return Menu(menu);
    } catch (e) {
      throw AppError(
          "Analiz Hatası",
          "Menü sitesini analiz ederken bir hata oluşmuştur. Bunun bir sebebi menü sitesinin HTML kodunun değişmesi olabilir"
              ". Öyle ise, bu hatayı düzeltmenin tek yolu uygulamayı güncellemektir. "
              "Şimdilik, menüye yenile butonuyla alternatif bir şekilde erişebilirsiniz.",
          e.toString(),
          Icons.code,
          () => launchUrl(MenuRepository.getMenuUri(schoolType), mode: LaunchMode.externalApplication));
    }
  }

  @override
  String toString() {
    return days.toString();
  }
}
