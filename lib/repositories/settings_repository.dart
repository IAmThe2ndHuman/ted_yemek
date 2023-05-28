import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// WROTE THIS ON A WHIM ITS SO BAD BRUH LITERALLY ALL OF SETTINGS JUST SUCKS
class SettingsRepository {
  // static const String _customColor = "data.settings.customColor";
  // static const String _useWallpaperColors = "data.settings.useWallpaperColors";
  static const String _brightness = "data.settings.brightness";

  static const String _lunchtimeHour = "data.settings.lunchtime.h";
  static const String _lunchtimeMinute = "data.settings.lunchtime.m";

  static const String _schoolType = "data.settings.school";

  final SharedPreferences preferences;
  // final bool supportsMaterial3;

  const SettingsRepository(this.preferences);

  AppBrightness get brightness => AppBrightness.fromId(preferences.getInt(_brightness));
  Future<void> setBrightness(AppBrightness value) async {
    await preferences.setInt(_brightness, value.id);
  }

  static const TimeOfDay defaultLunchtimeTime = TimeOfDay(hour: 12, minute: 10);
  TimeOfDay get lunchtimeTime => TimeOfDay(
      hour: preferences.getInt(_lunchtimeHour) ?? defaultLunchtimeTime.hour,
      minute: preferences.getInt(_lunchtimeMinute) ?? defaultLunchtimeTime.minute);
  Future<void> setLunchtimeTime(TimeOfDay timeOfDay) async {
    await preferences.setInt(_lunchtimeHour, timeOfDay.hour);
    await preferences.setInt(_lunchtimeMinute, timeOfDay.minute);
  }

  SchoolType get schoolType => SchoolType.fromId(preferences.getInt(_schoolType));
  Future<void> setSchoolType(SchoolType schoolType) async {
    await preferences.setInt(_schoolType, schoolType.id);
  }
// bool get useWallpaperColors => preferences.getBool(_useWallpaperColors) ?? true;
  // Future<void> setUseWallpaperColors(bool value) async {
  //   await preferences.setBool(_useWallpaperColors, value);
  // }
  //
  // Color get customColor {
  //   final hex = preferences.getInt(_customColor);
  //   if (hex == null) return Colors.blue;
  //   return Color(hex);
  // }
  //
  // Future<void> setCustomColor(Color value) async {
  //   await preferences.setInt(_customColor, value.value);
  // }
}

enum SchoolType {
  high(3),
  middle(2),
  kindergarten(1);

  final int id;
  const SchoolType(this.id);

  factory SchoolType.fromId(int? value) {
    switch (value) {
      case 1:
        return SchoolType.kindergarten;
      case 2:
        return SchoolType.middle;
      case _:
        return SchoolType.high;
    }
  }

  @override
  String toString() {
    switch (this) {
      case SchoolType.kindergarten:
        return "Anaokul";
      case SchoolType.middle:
        return "İlkokul";
      case SchoolType.high:
        return "Lise/Ortaokul";
    }
  }
}

enum AppBrightness {
  device(null, 2, "Cihazın temasına uymaktadır"),
  light(Brightness.light, 0, "Gündüz modundadır"),
  dark(Brightness.dark, 1, "Gece modundadır");

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

  factory AppBrightness.fromMaterialBrightness(Brightness value) {
    switch (value) {
      case Brightness.light:
        return AppBrightness.light;
      case Brightness.dark:
        return AppBrightness.dark;
    }
  }
}
