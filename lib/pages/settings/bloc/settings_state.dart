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
  final bool useWallpaperColors;
  final Color customColor;
  final bool supportsMaterial3;

  const SettingsInitialized(this.brightness, this.useWallpaperColors, this.customColor, this.supportsMaterial3);

  @override
  List<Object> get props => [brightness, useWallpaperColors, customColor, supportsMaterial3];
}
