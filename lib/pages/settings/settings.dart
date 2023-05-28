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

  List<Widget> _settingsBuilder(BuildContext context, SettingsState state) {
    final cubit = context.read<SettingsCubit>();

    return [
      const SettingHeaderTile(title: "Görünüş"),
      SettingTile(
        title: "Gece modu",
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
      const Divider(),
      const SettingHeaderTile(title: "Menü"),
      SettingTile(
        title: "Yemek saati",
        description: "Yemek zilinin saati",
        actions: [
          IconButton(
            onPressed: () async {
              final time = await showTimePicker(context: context, initialTime: state.lunchtimeTime);
              if (time != null) {
                await cubit.setLunchtimeTime(time);
              }
            },
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text(state.lunchtimeTime.format(context), style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(width: 15),
                  const Icon(Icons.edit_outlined)
                ],
              ),
            ),
          )
        ],
      ),
      SettingTile(
        title: "Okul menüsü",
        description: "Uygulamanın gösterdiği menü",
        actions: [
          PopupMenuButton<SchoolType>(
              icon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.schoolType.toString(),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )
                  ],
                ),
              ),
              onSelected: (schoolType) => cubit.setSchoolType(schoolType),
              itemBuilder: (context) => [
                    for (final schoolType in SchoolType.values)
                      CheckedPopupMenuItem(
                        checked: schoolType == state.schoolType,
                        value: schoolType,
                        child: Text(schoolType.toString()),
                      )
                  ])
        ],
      ),
      const Divider(),
      const SettingHeaderTile(title: "Hakkında"),
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
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: _settingsBuilder(context, state),
          );
        },
      ),
    );
  }
}
