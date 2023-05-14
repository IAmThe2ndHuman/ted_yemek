import 'package:flutter/material.dart';

class DayTile extends StatelessWidget {
  final String dayOfTheWeek;
  const DayTile({Key? key, required this.dayOfTheWeek}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Row(
        children: [
          Text(dayOfTheWeek, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(width: 10),
          const Expanded(child: Divider())
        ],
      ),
    );
  }
}
