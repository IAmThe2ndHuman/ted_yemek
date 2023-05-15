import 'package:flutter/material.dart';

import '../../../models/day.dart';
import 'dish_card.dart';
import 'until_lunch_timer.dart';

class DailyMenuCard extends StatelessWidget {
  final Day today;
  final Duration? timeUntilLunch;

  DailyMenuCard({Key? key, required this.today})
      : timeUntilLunch = today.durationUntilLunch(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
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
                  today.dayOfTheWeek,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).textTheme.titleLarge?.color?.withOpacity(0.5),
                      ),
                ),
              ],
            ),
            for (var dish in today.dishes) DishCard(dishName: dish, dense: true),
            const SizedBox(height: 5),
            timeUntilLunch != null
                ? UntilLunchTimer(timeUntilLunch!)
                : Text("YEMEK ZİLİ GEÇMİŞTİR", style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}
