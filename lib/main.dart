import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ted_yemek/pages/home/bloc/favorites/favorites_cubit.dart';
import 'package:ted_yemek/repositories/favorites_repository.dart';
import 'package:ted_yemek/repositories/menu_repository.dart';
import 'package:ted_yemek/services/isolate_service.dart';
import 'package:ted_yemek/services/notification_service.dart';

import 'pages/home/bloc/menu/menu_cubit.dart';
import 'pages/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting("tr_TR");

  await NotificationService.initialize();
  await IsolateService.initialize();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    NotificationService.setListeners();

    return DynamicColorBuilder(builder: (light, dark) {
      return MaterialApp(
        title: 'Ted Menü',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: light ?? ThemeData.light().colorScheme,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: dark ?? ThemeData.dark().colorScheme,
          cardColor: dark?.onSurface,
        ),
        home: MultiRepositoryProvider(
          providers: [
            // WOULD IT MAKE MORE SENSE TO JUST HAVE ONE SHAREDPREFS REPOSITORY AND PASS PREFS TO THE OTHERS???
            RepositoryProvider<MenuRepository>(create: (_) => MenuRepository()),
            RepositoryProvider<FavoritesRepository>(create: (_) => FavoritesRepository()),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<MenuCubit>(create: (context) => MenuCubit(context.read<MenuRepository>())),
              BlocProvider<FavoritesCubit>(create: (context) => FavoritesCubit(context.read<FavoritesRepository>())),
            ],
            child: const Home(),
          ),
        ),
      );
    });
  }
}
