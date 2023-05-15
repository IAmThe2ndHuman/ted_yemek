import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ted_yemek/models/error.dart';
import 'package:ted_yemek/repositories/menu_repository.dart';

import '../../../models/menu.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeInitial());

  Future<void> initializeMenu() async {
    emit(const HomeLoadingMenu());
    try {
      var menu = Menu.parseHtml(await MenuRepository.getMenuHtml());
      emit(HomeMenuAcquired(menu));
    } catch (e) {
      emit(HomeError(AppError(
          "Bağlantı veya önbellek hatası",
          "Menüyü görebilmek için internete bağlanmanız "
              "gerekmektedir. Bir kez bağlandıktan sonra bu haftanın menüsünü internetsiz görebileceksiniz.\n\nİnternete "
              "bağlıyken bile bu hatayı görüyorsanız muhtemelen sitenin html'i değişmiştir veya direk çökmüştür.",
          "${e.runtimeType}\n$e")));
    }
  }
}
