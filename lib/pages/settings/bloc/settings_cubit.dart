import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../repositories/settings_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _settingsRepository;
  SettingsCubit(this._settingsRepository) : super(const SettingsInitial());

  void initialize() {
    emit(SettingsInitialized(_settingsRepository.brightness, _settingsRepository.lunchtimeTime));
  }

  // Future<void> setUseWallpaperColors(bool value) async {
  //   await _settingsRepository.setUseWallpaperColors(value);
  //   await initialize();
  // }

  Future<void> setBrightness(AppBrightness value) async {
    await _settingsRepository.setBrightness(value);
    emit(SettingsInitialized(value, (state as SettingsInitialized).lunchtimeTime));
  }

  Future<void> setLunchtimeTime(TimeOfDay timeOfDay) async {
    await _settingsRepository.setLunchtimeTime(timeOfDay);
    emit(SettingsInitialized((state as SettingsInitialized).brightness, timeOfDay));
  }
}
