import 'package:flutter/material.dart';

class DishCard extends StatelessWidget {
  final String dishName;
  final bool dense;
  // final Icon? _dishIcon;

  const DishCard({Key? key, required this.dishName, this.dense = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: dense ? const EdgeInsets.symmetric(horizontal: 0) : null,
      dense: true,
      title: Text(dishName, style: Theme.of(context).textTheme.bodyLarge),
      leading: const Icon(Icons.remove),
    );
  }
}
