import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ted_yemek/constants.dart';
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
      // SizedBox(
      //   height: 8,
      // ),
      const SettingHeaderTile(title: "Hakkında"),
      // SettingTile(title: "Yazılımcı", description: "Koray Öztürkler"),
      // FutureBuilder<PackageInfo>(
      //   future: PackageInfo.fromPlatform(),
      //   builder: (context, snapshot) => SettingTile(title: "Sürüm", description: "v${snapshot.data?.version}"),
      // ),
      Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 10),
                  Text(
                    appName,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text("YAZILIMCI", style: Theme.of(context).textTheme.labelSmall),
              GestureDetector(
                onLongPress: () => showDialog(
                    context: context,
                    builder: (_) => SimpleDialog(
                          children: [Image.asset("assets/moment.png")],
                        )),
                child: Text(
                  "Koray Öztürkler",
                ),
              ),
              const SizedBox(height: 10),
              Text("SÜRÜM", style: Theme.of(context).textTheme.labelSmall),
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) => Text("v${snapshot.data?.version}"),
              ),
              const SizedBox(height: 10),
              Text("SDK SÜRÜMÜ", style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 5),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/flutter.svg",
                    colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSurface, BlendMode.srcIn),
                    height: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "v3.7.0",
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
              SizedBox(height: 10),
              Divider(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      "assets/VAKIF_LOGO.png",
                      scale: 8,
                    ),
                    Flexible(
                      child: Text("TED İSTANBUL KOLEJİ VAKFI", style: Theme.of(context).textTheme.labelLarge),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
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
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: _settingsBuilder(context, state),
          );
        },
      ),
    );
  }
}
