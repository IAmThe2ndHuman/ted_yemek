import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/menu.dart';
import '../components/daily_menu_card.dart';
import '../components/day_tile.dart';
import '../components/dish_card.dart';

class MenuView extends StatelessWidget {
  final Menu menu;
  const MenuView({Key? key, required this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final today = menu.today;

    return ListView(
      children: [
        Text("${DateFormat("d MMMM", "tr_TR").format(menu.days.first.date)} ve sonrası için menü",
            textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelSmall),
        if (today != null) DailyMenuCard(today: today),
        for (var day in menu.days) ...[
          DayTile(dayOfTheWeek: DateFormat("EEEE", "tr_TR").format(day.date)),
          for (var dish in day.dishes) DishCard(dishName: dish)
        ]
      ],
    );
  }
}
