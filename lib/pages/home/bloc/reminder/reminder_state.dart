part of 'reminder_cubit.dart';

sealed class ReminderState extends Equatable {
  final bool sawDialog;
  const ReminderState(this.sawDialog);

  @override
  List<Object> get props => [sawDialog];
}

class ReminderInitial extends ReminderState {
  const ReminderInitial(super.sawDialog);
}

class ReminderEnabled extends ReminderState {
  final TimeOfDay timeOfReminder;
  const ReminderEnabled(super.sawDialog, this.timeOfReminder);

  @override
  List<Object> get props => [timeOfReminder, sawDialog];
}

class ReminderDisabled extends ReminderState {
  const ReminderDisabled(super.sawDialog);
}
