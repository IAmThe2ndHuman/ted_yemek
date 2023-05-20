import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/menu.dart';
import '../../../../services/isolate_service.dart';

part 'reminder_state.dart';

class ReminderCubit extends Cubit<ReminderState> {
  ReminderCubit() : super(const ReminderInitial(false));

  Future<void> initializeReminder() async {
    final timeOfReminder = await IsolateService.timeOfReminder;

    if (timeOfReminder.timeOfDay == null) {
      emit(ReminderDisabled(timeOfReminder.sawReminderDialog));
    } else {
      emit(ReminderEnabled(timeOfReminder.sawReminderDialog, timeOfReminder.timeOfDay!));
    }
  }

  Future<void> enableReminder(Menu menu, TimeOfDay time) async {
    await IsolateService.scheduleReminders(menu, time);
    emit(ReminderEnabled(true, time));
  }

  Future<void> editReminder(Menu menu, TimeOfDay time) async {
    await IsolateService.cancelAll(edit: true);
    await IsolateService.scheduleReminders(menu, time);
    emit(ReminderEnabled(true, time));
  }

  Future<void> disableReminder() async {
    await IsolateService.cancelAll();
    emit(const ReminderDisabled(true));
  }
}
