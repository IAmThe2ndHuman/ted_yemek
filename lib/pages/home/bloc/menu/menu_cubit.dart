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
      emit(MenuLoaded(Menu.fromHtml(await _menuRepository.getMenuHtml())));
    } catch (e) {
      emit(MenuError(AppError(
          "Bağlantı veya önbellek hatası",
          "Menüyü görebilmek için internete bağlanmanız "
              "gerekmektedir. Bir kez bağlandıktan sonra bu haftanın menüsünü internetsiz görebileceksiniz.\n\nİnternete "
              "bağlıyken bile bu hatayı görüyorsanız muhtemelen sitenin html'i değişmiştir veya direk çökmüştür.",
          "${e.runtimeType}\n$e")));
    }
  }
}
