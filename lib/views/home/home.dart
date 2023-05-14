import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/menu.dart';
import '../../repositories/menu_repository.dart';
import 'components/daily_menu_card.dart';
import 'components/day_tile.dart';
import 'components/dish_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> menu = [];

  Future<void> _updateMenu() async {
    var weeklyMenu = Menu.parseHtml(await MenuRepository.getMenuHtml());
    var today = kDebugMode ? weeklyMenu.days[0] : weeklyMenu.today;

    setState(() {
      menu = [
        Text("${weeklyMenu.mondayDate} ve sonrası için menü",
            textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelSmall),
        if (today != null) DailyMenuCard(today: today),
        for (var day in weeklyMenu.days) ...[
          DayTile(dayOfTheWeek: day.dayOfTheWeek),
          for (var dish in day.dishes) DishCard(dishName: dish)
        ]
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TED Yemek Menüsü"),
      ),
      body: ListView(
        children: menu,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateMenu,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
