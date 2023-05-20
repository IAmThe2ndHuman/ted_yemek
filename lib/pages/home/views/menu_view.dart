import 'package:flutter/material.dart';
import 'package:ted_yemek/pages/home/components/no_dishes_card.dart';

import '../../../models/menu.dart';
import '../components/daily_menu_card.dart';
import '../components/day_tile.dart';
import '../components/dish_tile.dart';

class MenuView extends StatelessWidget {
  final Menu menu;
  const MenuView({Key? key, required this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final today = menu.today;

    return ListView(
      children: [
        if (today != null) DailyMenuCard(today: today),
        for (final day in menu.days) ...[
          DayTile(date: day.date),
          if (day.dishes.isEmpty) NoDishesCard(date: day.date),
          for (final dish in day.dishes) DishTile(dishName: dish)
        ]
      ],
    );
  }
}
