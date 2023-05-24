import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../repositories/settings_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _settingsRepository;
  SettingsCubit(this._settingsRepository) : super(const SettingsInitial());

  Future<void> initialize() async {
    emit(SettingsInitialized(_settingsRepository.brightness, _settingsRepository.useWallpaperColors,
        _settingsRepository.customColor, _settingsRepository.supportsMaterial3));
  }

  Future<void> setUseWallpaperColors(bool value) async {
    await _settingsRepository.setUseWallpaperColors(value);
    await initialize();
  }

  Future<void> setBrightness(AppBrightness value) async {
    await _settingsRepository.setBrightness(value);
    await initialize();
  }
}
