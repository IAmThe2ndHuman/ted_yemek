import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../models/error.dart';
import '../../../../models/menu.dart';
import '../../../../repositories/menu_repository.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuRepository _menuRepository;
  MenuCubit(this._menuRepository) : super(const MenuInitial());

  Future<void> initializeMenu() async {
    emit(const MenuLoading());

    try {
      var html = await _menuRepository.getCachedHtml();
      var cache = false;

      if (html == null) {
        html = await _menuRepository.fetchMenuHtml();
        cache = true;
      }

      final menu = Menu.fromHtml(html);
      emit(MenuLoaded(menu));

      if (cache) await _menuRepository.setCacheHtml(html);
    } on AppError catch (e) {
      emit(MenuError(e));
    } catch (e) {
      emit(MenuError(AppError("Bilimneyen Hata", "Bilinmeyen bir hata oluşmuştur.", "${e.runtimeType}\n$e")));
    }
  }
}
