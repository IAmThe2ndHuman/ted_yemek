import 'package:flutter/material.dart';

import '../../../models/menu.dart';
import '../components/daily_menu_card.dart';
import '../components/day_tile.dart';
import '../components/dish_card.dart';

class MenuView extends StatelessWidget {
  final Menu menu;
  const MenuView({Key? key, required this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var today = menu.today;
    return ListView(
      children: [
        Text("${menu.mondayDate} ve sonrası için menü",
            textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelSmall),
        if (today != null) DailyMenuCard(today: today),
        for (var day in menu.days) ...[
          DayTile(dayOfTheWeek: day.dayOfTheWeek),
          for (var dish in day.dishes) DishCard(dishName: dish)
        ]
      ],
    );
  }
}
