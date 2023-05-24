import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ted_yemek/pages/settings/bloc/settings_cubit.dart';
import 'package:ted_yemek/repositories/settings_repository.dart';

// UGLY LAST MINUTE ADDITION
class Settings extends StatelessWidget {
  static const String routeName = "/settings";
  Settings({Key? key}) : super(key: key);

  List<Widget> _settingsBuilder(BuildContext context, SettingsInitialized state) {
    final cubit = context.read<SettingsCubit>();

    return [
      Padding(
        padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
        child: Text(
          "Görünüş",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      ListTile(
          leading: const Icon(Icons.dark_mode),
          title: const Text("Tema"),
          subtitle: Text(state.brightness.description),
          trailing: PopupMenuButton<AppBrightness>(
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Text(state.brightness.toString()), SizedBox(width: 5), Icon(Icons.arrow_drop_down)],
              ),
              onSelected: (brightness) => cubit.setBrightness(brightness),
              itemBuilder: (context) => [
                    for (final brightness in AppBrightness.values)
                      CheckedPopupMenuItem(
                        checked: brightness == state.brightness,
                        value: brightness,
                        child: Text(brightness.toString()),
                      )
                  ])),
      if (state.supportsMaterial3)
        ListTile(
          title: Text("Material You"),
          subtitle: Text("UI renkleri duvar kağıdından al."),
          leading: Icon(Icons.palette),
          trailing: Switch(value: state.useWallpaperColors, onChanged: (value) => cubit.setUseWallpaperColors(value)),
        ),
      if (!state.supportsMaterial3 || !state.useWallpaperColors)
        ListTile(
          title: Text("Accent color"),
          subtitle: Text("Change the UI colors"),
          leading: Icon(Icons.format_color_fill),
          onTap: () {},
          trailing: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(shape: BoxShape.circle, color: state.customColor),
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ayarlar")),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsInitialized) {
            return ListView(
              children: _settingsBuilder(context, state),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
