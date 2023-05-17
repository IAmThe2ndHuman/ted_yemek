import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ted_yemek/repositories/favorites_repository.dart';

import '../bloc/favorites/favorites_cubit.dart';

class DishCard extends StatefulWidget {
  final String dishName;
  final bool dense;
  // final Icon? _dishIcon;

  const DishCard({Key? key, required this.dishName, this.dense = false})
      : super(key: key);

  @override
  State<DishCard> createState() => _DishCardState();
}

class _DishCardState extends State<DishCard> {
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
        contentPadding:
            widget.dense ? const EdgeInsets.symmetric(horizontal: 0) : null,
        dense: true,
        title:
            Text(widget.dishName, style: Theme.of(context).textTheme.bodyLarge),
        leading: const Icon(Icons.remove),
        trailing: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            return FutureBuilder<List<String>>(
              future: state.favorites,
              builder: (context, snapshot) {
                // this might be bad code
                bool favorited;
                if (state is FavoriteAdded &&
                    state.addedDish == widget.dishName) {
                  favorited = true;
                } else if (state is FavoriteRemoved &&
                    state.removedDish == widget.dishName) {
                  favorited = false;
                } else {
                  favorited = snapshot.data?.contains(widget.dishName) ?? false;
                }

                return IconButton(
                    icon: Icon(
                        favorited ? Icons.favorite : Icons.favorite_border),
                    onPressed: () => toggleFavorite(favorited));
              },
            );
          },
        ));
  }
}
