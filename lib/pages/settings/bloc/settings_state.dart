part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final AppBrightness brightness;
  final TimeOfDay lunchtimeTime;
  final SchoolType schoolType;

  const SettingsState(this.brightness, this.lunchtimeTime, this.schoolType);

  @override
  List<Object> get props => [brightness, lunchtimeTime, schoolType];
}
