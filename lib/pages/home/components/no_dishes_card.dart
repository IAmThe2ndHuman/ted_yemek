import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoDishesCard extends StatelessWidget {
  final DateTime date;
  const NoDishesCard({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: ListTile(
          leading: const Icon(Icons.not_interested),
          title: Text("${DateFormat("EEEE", "tr_TR").format(date)} için yemek bulunmamaktadır."),
        ));
  }
}
