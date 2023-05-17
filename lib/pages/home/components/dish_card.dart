import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ted_yemek/repositories/favorites_repository.dart';

class DishCard extends StatefulWidget {
  final String dishName;
  final bool dense;
  // final Icon? _dishIcon;

  const DishCard({Key? key, required this.dishName, this.dense = false})
      : super(key: key);

  @override
  State<DishCard> createState() => _DishCardState();
}

class _DishCardState extends State<DishCard> with AfterLayoutMixin {
  bool toggled = false;

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    toggled =
        await context.read<FavoritesRepository>().isFavorite(widget.dishName);
    setState(() {});
  }

  Future<void> toggleFavorite() async {
          setState(() => toggled = !toggled);
    if (!toggled) {
      await context.read<FavoritesRepository>().removeFavorite(widget.dishName);
    } else {
      await context.read<FavoritesRepository>().addFavorite(widget.dishName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          widget.dense ? const EdgeInsets.symmetric(horizontal: 0) : null,
      dense: true,
      title:
          Text(widget.dishName, style: Theme.of(context).textTheme.bodyLarge),
      leading: const Icon(Icons.remove),
      trailing: IconButton(
          icon: Icon(toggled ? Icons.favorite : Icons.favorite_border),
          onPressed: toggleFavorite),
    );
  }
}
