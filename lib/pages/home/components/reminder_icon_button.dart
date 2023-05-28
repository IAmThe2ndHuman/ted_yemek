import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ted_yemek/constants.dart';

import '../../../services/notification_service.dart';
import '../bloc/menu/menu_cubit.dart';
import '../bloc/reminder/reminder_cubit.dart';

enum _ReminderButtonBehavior { enable, disable, edit }

class ReminderIconButton extends StatelessWidget {
  const ReminderIconButton({Key? key}) : super(key: key);

  Future<void> _enableReminder(BuildContext context, {bool edit = false}) async {
    final menuState = context.read<MenuCubit>().state;
    final reminderCubit = context.read<ReminderCubit>();

    _ReminderButtonBehavior? choice = _ReminderButtonBehavior.enable;
    if (!reminderCubit.state.sawDialog) {
      choice = await showDialog<_ReminderButtonBehavior>(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text(notificationTitle),
                icon: const Icon(Icons.notifications_outlined),
                content: const Text(
                    "Belirli günlerde beğendiğiniz bir yemek mevcut ise dilediğiniz saatte hatırlatılabilirsiniz."),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("İPTAL")),
                  TextButton(
                      onPressed: () => Navigator.pop(context, _ReminderButtonBehavior.enable),
                      child: const Text("DEVAM")),
                ],
              ));
    }

    final bool canNotify = choice == _ReminderButtonBehavior.enable &&
        await NotificationService.requestNotificationAccess() &&
        menuState is MenuLoaded;

    if (context.mounted && canNotify) {
      final state = reminderCubit.state;
      final timeDefault = state is ReminderEnabled ? state.timeOfReminder : TimeOfDay.now();

      final time = await showTimePicker(
          context: context,
          initialTime: timeDefault, // TODO: if edit show selected time lol
          helpText: "Hatırlatılmak istediğiniz saati seçin.",
          cancelText: "İPTAL",
          confirmText: "KUR");
      if (time != null && context.mounted) {
        _modifyReminder(context, time);

        if (edit) {
          await reminderCubit.editReminder(menuState.menu, time);
        } else {
          await reminderCubit.enableReminder(menuState.menu, time);
        }
      }
    }
  }

  Future<void> _modifyReminder(BuildContext context, TimeOfDay time) async {
    final choice = await showDialog<_ReminderButtonBehavior>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(notificationTitle),
              icon: const Icon(Icons.notifications_active_outlined),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Beğendiğiniz bir yemek belirli bir günde mevcut ise, size hatırlatılacaktır."),
                  const SizedBox(height: 10),
                  Text(
                    "HATIRLATILACAK SAAT",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(time.format(context), style: Theme.of(context).textTheme.displaySmall),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () => Navigator.pop(context, _ReminderButtonBehavior.edit),
                              tooltip: "Düzenle",
                              icon: const Icon(Icons.edit_outlined)),
                          IconButton(
                              onPressed: () => Navigator.pop(context, _ReminderButtonBehavior.disable),
                              tooltip: "Kapat",
                              icon: const Icon(Icons.delete_outline))
                        ],
                      )
                    ],
                  )
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("TAMAM")),
              ],
            ));

    if (context.mounted) {
      switch (choice) {
        case _ReminderButtonBehavior.disable:
          final choice = await showDialog<_ReminderButtonBehavior>(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("Bildirimleri Kapatmak"),
                    icon: const Icon(Icons.notifications_active_outlined),
                    content: const Text("Bildirimleri kapatmak istediğinizden emin misiniz?"),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, _ReminderButtonBehavior.disable),
                          child: const Text("EVET")),
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text("HAYIR")),
                    ],
                  ));

          if (choice == _ReminderButtonBehavior.disable && context.mounted) {
            context.read<ReminderCubit>().disableReminder();
            showDialog<_ReminderButtonBehavior>(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text("Bildirimler Kapatılmıştır"),
                      icon: const Icon(Icons.notifications_off_outlined),
                      content: const Text("Bildirim almaya devam etmeyeceksiniz."),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text("TAMAM")),
                      ],
                    ));
          }
          break;
        case _ReminderButtonBehavior.edit:
          _enableReminder(context, edit: true);
          break;
        case _:
          break;
      }
    }
  }

  IconData _iconBuilder(ReminderState state) {
    if (state is ReminderEnabled) {
      final now = DateTime.now();

      final reminderTime = state.timeOfReminder.hour + state.timeOfReminder.minute / 60.0;
      final currentTime = now.hour + now.minute / 60.0;

      if (now.weekday > 5) {
        return Icons.notifications_outlined;
      } else if (currentTime > reminderTime) {
        return Icons.notifications;
      }
      return Icons.notifications_active;
    }
    return Icons.notification_add_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReminderCubit, ReminderState>(builder: (context, state) {
      final bool enabled = state is ReminderEnabled;

      return IconButton.filledTonal(
          style: enabled ? null : ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.transparent)),
          onPressed: () => enabled ? _modifyReminder(context, state.timeOfReminder) : _enableReminder(context),
          icon: AnimatedSize(
            duration: const Duration(milliseconds: 400),
            alignment: Alignment.centerLeft,
            curve: Curves.easeInOutCubic,
            child: Padding(
              padding: enabled ? const EdgeInsets.symmetric(horizontal: 5) : EdgeInsets.zero,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_iconBuilder(state)),
                  if (enabled) ...[
                    const SizedBox(width: 5),
                    Text(
                      state.timeOfReminder.format(context),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ]
                ],
              ),
            ),
          ));
      // if (state is ReminderEnabled) {
      //   return IconButton.filledTonal(
      //       style: ButtonStyle(
      //           backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondaryContainer)),
      //       onPressed: () => _modifyReminder(context, state.timeOfDay),
      //       icon: Row(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           const Icon(Icons.notifications_active),
      //           const SizedBox(width: 5),
      //           Text(
      //             state.timeOfDay.format(context),
      //             style: Theme.of(context).textTheme.labelLarge,
      //           )
      //         ],
      //       ));
      // } else {
      //   return IconButton(
      //       onPressed: () => _enableReminder(context), icon: const Icon(Icons.notification_add_outlined));
    });
  }
}

// extension on TimeOfDay {
//   String formatString() {
//     return "${hour.toString()}:${minute.toString().padLeft(2, "0")}";
//   }
// }
