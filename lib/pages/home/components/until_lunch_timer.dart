import 'dart:async';

import 'package:flutter/material.dart';

class UntilLunchTimer extends StatefulWidget {
  final Duration durationUntilLunch;

  const UntilLunchTimer(this.durationUntilLunch, {Key? key}) : super(key: key);

  @override
  State<UntilLunchTimer> createState() => _UntilLunchTimerState();
}

class _UntilLunchTimerState extends State<UntilLunchTimer> {
  late Timer _timeUntilLunch;
  late int _secondsUntilLunch;

  void _initializeTimer() {
    _secondsUntilLunch = widget.durationUntilLunch.inSeconds;
    _timeUntilLunch = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsUntilLunch <= 0) {
        timer.cancel();
      } else {
        setState(() {
          _secondsUntilLunch--;
        });
      }
    });
  }

  @override
  void initState() {
    _initializeTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timeUntilLunch.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sec = (_secondsUntilLunch % 60).toString().padLeft(2, "0");
    var minPre = (_secondsUntilLunch / 60).floor();
    var min = (minPre % 60).toString().padLeft(2, "0");
    var hour = (minPre / 60).floor().toString().padLeft(2, "0");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("YEMEĞE KALAN SÜRE", style: Theme.of(context).textTheme.labelMedium),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          alignment: Alignment.topLeft,
          child: Text(_secondsUntilLunch == 0 ? "BİRAZDAN ZİL ÇALAR :)" : "$hour:$min:$sec",
              style: Theme.of(context).textTheme.displayMedium),
        ),
      ],
    );
  }
}
