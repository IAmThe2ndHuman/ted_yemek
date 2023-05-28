import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ted_yemek/pages/settings/bloc/settings_cubit.dart';

class UntilLunchTimer extends StatefulWidget {
  final Duration? Function(TimeOfDay) durationUntilLunchCallback;

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
    final state = context.read<SettingsCubit>().state;

    if (state is SettingsInitialized) {
      _secondsUntilLunch = widget.durationUntilLunchCallback(state.lunchtimeTime)?.inSeconds;
    }
    _timeUntilLunch?.cancel();
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
    } else {
      setState(() {});
    }
  }

  Widget _timerBuilder() {
    if (_secondsUntilLunch != null && _timeUntilLunch != null) {
      final sec = (_secondsUntilLunch! % 60).toString().padLeft(2, "0");
      final minPre = (_secondsUntilLunch! / 60).floor();
      final min = (minPre % 60).toString().padLeft(2, "0");
      final hour = (minPre / 60).floor().toString().padLeft(2, "0");

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("YEMEK ZİLİNE KALAN SÜRE", style: Theme.of(context).textTheme.labelMedium),
          Text("$hour:$min:$sec", style: Theme.of(context).textTheme.displayMedium),
        ],
      );
    } else {
      return Text("YEMEK ZİLİ ÇALMIŞTIR", style: Theme.of(context).textTheme.labelMedium);
    }
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
    return BlocListener<SettingsCubit, SettingsState>(
      listener: (context, state) => _initializeTimer(),
      listenWhen: (prev, current) =>
          (current is SettingsInitialized && prev is SettingsInitialized) &&
          (current.lunchtimeTime != prev.lunchtimeTime),
      child: _timerBuilder(),
    );
  }
}
