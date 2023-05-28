import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/favorites/favorites_cubit.dart';

class DishTile extends StatefulWidget {
  final String dishName;
  final bool dense;
  // final Icon? _dishIcon;

  const DishTile({Key? key, required this.dishName, this.dense = false}) : super(key: key);

  @override
  State<DishTile> createState() => _DishTileState();
}

class _DishTileState extends State<DishTile> {
  Future<void> toggleFavorite(bool favorited) async {
    if (favorited) {
      await context.read<FavoritesCubit>().removeFavorite(widget.dishName);
    } else {
      await context.read<FavoritesCubit>().addFavorite(widget.dishName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: widget.dense ? const EdgeInsets.symmetric(horizontal: 0) : null,
        dense: true,
        title: Text(widget.dishName, style: Theme.of(context).textTheme.bodyLarge),
        leading: const Icon(Icons.remove),
        trailing: Platform.isAndroid ? BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            bool favorited = false;
            if (state is FavoriteAdded && state.addedDish == widget.dishName) {
              favorited = true;
              // } else if (state is FavoriteRemoved && state.removedDish == widget.dishName) {
              //   favorited = false;
            } else if (state is FavoritesLoaded && state.favorites.contains(widget.dishName)) {
              favorited = true;
            }

            return IconButton(
                icon: Icon(favorited ? Icons.favorite : Icons.favorite_border),
                onPressed: () => toggleFavorite(favorited));
          },
        ) : null);
  }
}
