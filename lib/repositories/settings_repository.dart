import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// WROTE THIS ON A WHIM ITS SO BAD BRUH LITERALLY ALL OF SETTINGS JUST SUCKS
class SettingsRepository {
  static const String _customColor = "data.settings.customColor";
  static const String _useWallpaperColors = "data.settings.useWallpaperColors";
  static const String _brightness = "data.settings.brightness";

  final SharedPreferences preferences;
  final bool supportsMaterial3;

  const SettingsRepository(this.preferences, this.supportsMaterial3);

  AppBrightness get brightness => AppBrightness.fromId(preferences.getInt(_brightness));
  Future<void> setBrightness(AppBrightness value) async {
    await preferences.setInt(_brightness, value.id);
  }

  bool get useWallpaperColors => preferences.getBool(_useWallpaperColors) ?? true;
  Future<void> setUseWallpaperColors(bool value) async {
    await preferences.setBool(_useWallpaperColors, value);
  }

  Color get customColor {
    final hex = preferences.getInt(_customColor);
    if (hex == null) return Colors.blue;
    return Color(hex);
  }

  Future<void> setCustomColor(Color value) async {
    await preferences.setInt(_customColor, value.value);
  }
}

enum AppBrightness {
  device(null, 2, "Cihazınızın temasına göre değişecektir."),
  light(Brightness.light, 0, "Gündüz modundadır."),
  dark(Brightness.dark, 1, "Gece modundadır.");

  final Brightness? materialBrightness;
  final int id;
  final String description;
  const AppBrightness(this.materialBrightness, this.id, this.description);

  factory AppBrightness.fromId(int? value) {
    switch (value) {
      case 0:
        return AppBrightness.light;
      case 1:
        return AppBrightness.dark;
      case _:
        return AppBrightness.device;
    }
  }

  @override
  String toString() {
    switch (this) {
      case light:
        return "Gündüz";
      case dark:
        return "Gece";
      case device:
        return "Otomatik";
    }
  }
}
