import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ted_yemek/repositories/favorites_repository.dart';
import 'package:ted_yemek/repositories/menu_repository.dart';

import 'pages/home/bloc/menu/menu_cubit.dart';
import 'pages/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
            // WOULD IT MAKE MORE SENSE TO JUST HAVE ONE SHAREDPREFS REPOSITORY AND PASS _PREFS TO THE OTHERS???
            RepositoryProvider<MenuRepository>(create: (_) => MenuRepository()),
            RepositoryProvider<FavoritesRepository>(create: (_) => FavoritesRepository())
          ],
          child: BlocProvider(
            create: (context) => MenuCubit(context.read<MenuRepository>()),
            child: const Home(),
          ),
        ),
      );
    });
  }
}
