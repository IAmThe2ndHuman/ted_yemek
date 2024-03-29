import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/error.dart';
import '../../settings/bloc/settings_cubit.dart';
import '../bloc/menu/menu_cubit.dart';

class ErrorView extends StatelessWidget {
  final AppError error;

  const ErrorView({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              error.icon ?? Icons.warning,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 60,
            ),
            const SizedBox(height: 10),
            Text(error.title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            Text(error.description, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: error.customCallback ??
                      () => context.read<MenuCubit>().initializeMenu(context.read<SettingsCubit>().state.schoolType),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Yenile"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () => error.details != null
                        ? showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Hata Detayları"),
                                content: SingleChildScrollView(child: Text(error.details!)),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("TAMAM"))
                                ],
                              );
                            })
                        : null,
                    child: const Text("Hata Detayları")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
