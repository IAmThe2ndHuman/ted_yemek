import 'dart:async';

import 'package:flutter/material.dart';

import '../components/dish_card.dart';

class FavoritesView extends StatelessWidget {
  final Future<List<String>> favorites;
  const FavoritesView({super.key, required this.favorites});

  Widget _errorBuilder(BuildContext context) {
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
          Text("Favori Bulunmamaktadır", textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          const Text("description", textAlign: TextAlign.center),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: favorites,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.isEmpty) {
            return _errorBuilder(context);
          } else {
            return ListView(
              children: [for (var dishName in snapshot.data!) DishCard(dishName: dishName)],
            );
          }
        });
  }
}
