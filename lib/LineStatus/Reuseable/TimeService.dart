import 'package:flutter/material.dart';
import 'dart:async';

class TimerService extends ChangeNotifier {
  static final TimerService _instance = TimerService._internal();
  factory TimerService() => _instance;

  Timer? _timer;
  int _secondsElapsed = 0;

  TimerService._internal();

  int get secondsElapsed => _secondsElapsed;

  void startTimer() {
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _secondsElapsed++;
        notifyListeners();
      });
    }
  }

  void resetTimer() {
    _secondsElapsed = 0;
    notifyListeners();
  }
}
