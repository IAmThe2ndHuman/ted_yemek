import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ted_yemek/constants.dart';
import 'package:ted_yemek/pages/settings/bloc/settings_cubit.dart';
import 'package:ted_yemek/pages/settings/settings.dart';
import 'package:ted_yemek/repositories/settings_repository.dart';

import 'pages/home/bloc/favorites/favorites_cubit.dart';
import 'pages/home/bloc/menu/menu_cubit.dart';
import 'pages/home/bloc/reminder/reminder_cubit.dart';
import 'pages/home/home.dart';
import 'repositories/favorites_repository.dart';
import 'repositories/menu_repository.dart';
import 'services/isolate_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  // final deviceInfoPlugin = DeviceInfoPlugin();

  await initializeDateFormatting("tr_TR");

  if (defaultTargetPlatform == TargetPlatform.android) {
    await IsolateService.initialize();
    await NotificationService.initialize();
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  if (!kIsWeb) {
      HttpOverrides.global = MyHttpOverrides(); // todo remove later????
  }

  runApp(MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MenuRepository>(
            create: (_) => MenuRepository(preferences)),
        RepositoryProvider<FavoritesRepository>(
            create: (_) => FavoritesRepository(preferences)),
        RepositoryProvider<SettingsRepository>(
            create: (_) => SettingsRepository(
                  preferences,
                ))
      ],
      child: BlocProvider(
          create: (context) =>
              SettingsCubit(context.read<SettingsRepository>()),
          child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationService.setListeners();

    return BlocBuilder<SettingsCubit, SettingsState>(builder: (context, state) {
      return DynamicColorBuilder(builder: (light, dark) {
        return MaterialApp(
          title: appName,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: light != null
                ? (state.brightness == AppBrightness.dark ? dark : light)
                : ColorScheme.fromSeed(
                    seedColor: Colors.blue,
                    brightness: state.brightness == AppBrightness.device
                        ? Brightness.light
                        : state.brightness.materialBrightness!),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: dark != null
                ? (state.brightness == AppBrightness.light ? light : dark)
                : ColorScheme.fromSeed(
                    seedColor: Colors.blue,
                    brightness: state.brightness == AppBrightness.device
                        ? Brightness.dark
                        : state.brightness.materialBrightness!),
          ),
          routes: {
            Home.routeName: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<MenuCubit>(
                        create: (context) =>
                            MenuCubit(context.read<MenuRepository>())),
                    BlocProvider<FavoritesCubit>(
                        create: (context) => FavoritesCubit(
                            context.read<FavoritesRepository>())),
                    BlocProvider<ReminderCubit>(
                        create: (context) => ReminderCubit()),
                  ],
                  child: const Home(),
                ),
            Settings.routeName: (context) => const Settings()
          },
          initialRoute: Home.routeName,
        );
      });
    });
  }
}
