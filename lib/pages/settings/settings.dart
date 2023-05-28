import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ted_yemek/pages/settings/bloc/settings_cubit.dart';
import 'package:ted_yemek/pages/settings/components/setting_header_tile.dart';
import 'package:ted_yemek/pages/settings/components/setting_tile.dart';

import '../../repositories/settings_repository.dart';

// UGLY LAST MINUTE ADDITION
class Settings extends StatelessWidget {
  static const String routeName = "/settings";
  const Settings({Key? key}) : super(key: key);

  List<Widget> _settingsBuilder(BuildContext context, SettingsInitialized state) {
    final cubit = context.read<SettingsCubit>();

    return [
      const SettingHeaderTile(title: "Görünüş"),
      SettingTile(
        title: "Gece Modu",
        description: state.brightness.description,
        actions: [
          IconButton.filledTonal(
            tooltip: "Otomatik",
            onPressed: () {
              if (state.brightness == AppBrightness.device) {
                cubit.setBrightness(AppBrightness.fromMaterialBrightness(Theme.of(context).brightness));
              } else {
                cubit.setBrightness(AppBrightness.device);
              }
            },
            icon: const Icon(Icons.auto_awesome),
            style: state.brightness == AppBrightness.device
                ? null
                : ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.transparent)),
          ),
          Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: state.brightness == AppBrightness.device
                  ? null
                  : (value) {
                      if (value) {
                        cubit.setBrightness(AppBrightness.dark);
                      } else {
                        cubit.setBrightness(AppBrightness.light);
                      }
                    })
        ],
      ),
      Divider(),
      const SettingHeaderTile(title: "Zaman"),
      SettingTile(
        title: "Yemek saati",
        description: "Yemek zilinin saati",
        actions: [
          Text("00:00", style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(width: 10),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit_outlined),
          )
        ],
      )
      // if (state.supportsMaterial3)
      //   ListTile(
      //     title: Text("Material You"),
      //     subtitle: Text("UI renkleri duvar kağıdından al."),
      //     leading: Icon(Icons.palette),
      //     trailing: Switch(value: state.useWallpaperColors, onChanged: (value) => cubit.setUseWallpaperColors(value)),
      //   ),
      // if (!state.supportsMaterial3 || !state.useWallpaperColors)
      //   ListTile(
      //     title: Text("Accent color"),
      //     subtitle: Text("Change the UI colors"),
      //     leading: Icon(Icons.format_color_fill),
      //     onTap: () {},
      //     trailing: Container(
      //       height: 30,
      //       width: 30,
      //       decoration: BoxDecoration(shape: BoxShape.circle, color: state.customColor),
      //     ),
      //   ),
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
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: _settingsBuilder(context, state),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
