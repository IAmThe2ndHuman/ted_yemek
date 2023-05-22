import 'package:flutter/material.dart';

import '../components/dish_tile.dart';

class FavoritesView extends StatelessWidget {
  final List<String> favorites;
  const FavoritesView({super.key, required this.favorites});

  Widget _noFavoritesBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            Icons.favorite_border,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 60,
          ),
          const SizedBox(height: 10),
          Text("Favori Bulunmamaktadır",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          const Text("Menü sayfasında beğendiğiniz yemekler burada olacaktır.",
              textAlign: TextAlign.center),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) return _noFavoritesBuilder(context);
    return ListView(
      children: [
        for (final dishName in favorites) DishTile(dishName: dishName)
      ],
    );
  }
}
