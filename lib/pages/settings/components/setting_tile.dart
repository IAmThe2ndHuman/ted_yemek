import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final String? description;
  final List<Widget>? actions;

  const SettingTile({Key? key, required this.title, this.description, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (description != null)
                  Text(
                    description!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).textTheme.titleLarge?.color?.withOpacity(0.7),
                        ),
                  )
              ],
            ),
          ),
          ...?actions
        ],
      ),
    );
  }
}
