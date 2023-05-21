import 'dart:async';

import 'package:flutter/material.dart';

class UntilLunchTimer extends StatefulWidget {
  final Duration? Function() durationUntilLunchCallback;

  const UntilLunchTimer(this.durationUntilLunchCallback, {Key? key}) : super(key: key);

  @override
  State<UntilLunchTimer> createState() => _UntilLunchTimerState();
}

class _UntilLunchTimerState extends State<UntilLunchTimer> with WidgetsBindingObserver {
  Timer? _timeUntilLunch;
  int? _secondsUntilLunch;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_secondsUntilLunch != null && _secondsUntilLunch != 0) {
      if (state == AppLifecycleState.paused) {
        _timeUntilLunch?.cancel();
      } else if (state == AppLifecycleState.resumed) {
        _initializeTimer();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  void _initializeTimer() {
    _secondsUntilLunch = widget.durationUntilLunchCallback()?.inSeconds;
    if (_secondsUntilLunch != null) {
      _timeUntilLunch = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsUntilLunch! <= 0) {
          timer.cancel();
        } else {
          setState(() {
            _secondsUntilLunch = _secondsUntilLunch! - 1;
          });
        }
      });
    }
  }

  Widget timerBuilder() {
    final sec = (_secondsUntilLunch! % 60).toString().padLeft(2, "0");
    final minPre = (_secondsUntilLunch! / 60).floor();
    final min = (minPre % 60).toString().padLeft(2, "0");
    final hour = (minPre / 60).floor().toString().padLeft(2, "0");

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

  @override
  void initState() {
    _initializeTimer();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timeUntilLunch?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_secondsUntilLunch != null && _timeUntilLunch != null) {
      return timerBuilder();
    } else {
      return Text("YEMEK ZİLİ GEÇMİŞTİR", style: Theme.of(context).textTheme.labelMedium);
    }
  }
}
