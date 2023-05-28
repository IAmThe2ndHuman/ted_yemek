import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ted_yemek/repositories/settings_repository.dart';

import '../../../../models/error.dart';
import '../../../../models/menu.dart';
import '../../../../repositories/menu_repository.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuRepository _menuRepository;
  MenuCubit(this._menuRepository) : super(const MenuInitial());

  Future<void> initializeMenu(SchoolType schoolType) async {
    emit(const MenuLoading());

    try {
      var html = await _menuRepository.getCachedHtml(schoolType);
      var cache = false;

      if (html == null) {
        html = await _menuRepository.fetchMenuHtml(schoolType);
        cache = true;
      }

      final menu = Menu.fromHtml(html, schoolType);
      emit(MenuLoaded(menu));

      if (cache) await _menuRepository.setCacheHtml(html, schoolType);
    } on AppError catch (e) {
      emit(MenuError(e));
    } catch (e) {
      emit(MenuError(AppError("Bilimneyen Hata", "Bilinmeyen bir hata oluşmuştur.", "${e.runtimeType}\n$e")));
    }
  }
}
