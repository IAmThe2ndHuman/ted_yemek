import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayTile extends StatelessWidget {
  final DateTime date;
  const DayTile({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Row(
        children: [
          Text(DateFormat("EEEE", "tr_TR").format(date), style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(width: 10),
          const Expanded(child: Divider()),
          const SizedBox(width: 10),
          Text(DateFormat("d MMMM", "tr_TR").format(date),
              textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelSmall)
        ],
      ),
    );
  }
}
