part of 'settings_cubit.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsInitialized extends SettingsState {
  final AppBrightness brightness;
  final TimeOfDay lunchtimeTime;
  // final bool useWallpaperColors;
  // final Color customColor;
  // final bool supportsMaterial3;

  const SettingsInitialized(this.brightness, this.lunchtimeTime);

  @override
  List<Object> get props => [brightness, lunchtimeTime];
}
