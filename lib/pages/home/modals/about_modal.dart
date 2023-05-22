import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../constants.dart';

class AboutModal extends StatelessWidget {
  final PackageInfo packageInfo;
  const AboutModal({super.key, required this.packageInfo});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("$appName Hakkında"),
      icon: const Icon(Icons.info_outline),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("YAZILIMCI", style: Theme.of(context).textTheme.labelSmall),
          const Text("Koray Öztürkler"),
          const SizedBox(height: 10),
          Text("SÜRÜM", style: Theme.of(context).textTheme.labelSmall),
          Text("v${packageInfo.version}"),
          const SizedBox(height: 10),
          Text("SDK SÜRÜMÜ", style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 5),
          Row(
            children: [
              SvgPicture.asset(
                "assets/flutter.svg",
                colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.onSurface, BlendMode.srcIn),
                height: 20,
              ),
              const SizedBox(width: 10),
              Text(
                "v3.7.0",
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  "assets/VAKIF_LOGO.png",
                  scale: 8,
                ),
                Text("TED İSTANBUL KOLEJİ VAKFI",
                    style: Theme.of(context).textTheme.labelSmall)
              ],
            ),
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: const Text("TAMAM"))
      ],
    );
  }
}
