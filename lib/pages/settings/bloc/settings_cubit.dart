import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../repositories/settings_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsRepository _settingsRepository;
  SettingsCubit(this._settingsRepository) : super(const SettingsInitial());

  Future<void> initialize() async {
    emit(SettingsInitialized(_settingsRepository.brightness));
  }

  // Future<void> setUseWallpaperColors(bool value) async {
  //   await _settingsRepository.setUseWallpaperColors(value);
  //   await initialize();
  // }

  Future<void> setBrightness(AppBrightness value) async {
    await _settingsRepository.setBrightness(value);
    await initialize();
  }
}
