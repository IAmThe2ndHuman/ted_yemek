import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/day.dart';
import 'dish_tile.dart';
import 'no_dishes_card.dart';
import 'until_lunch_timer.dart';

class DailyMenuCard extends StatelessWidget {
  final Day today;

  const DailyMenuCard({Key? key, required this.today}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Günlük Menü",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  DateFormat("EEEE", "tr_TR").format(today.date),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).textTheme.titleLarge?.color?.withOpacity(0.5),
                      ),
                ),
              ],
            ),
            if (today.dishes.isEmpty) NoDishesCard(date: today.date, dense: true),
            for (final dish in today.dishes) DishTile(dishName: dish, dense: true),
            const SizedBox(height: 5),
            UntilLunchTimer(today.durationUntilLunch)
          ],
        ),
      ),
    );
  }
}
