import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/home/bloc/home_cubit.dart';
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
        home: BlocProvider(
          create: (context) => HomeCubit(),
          child: const Home(),
        ),
      );
    });
  }
}
