import 'package:flutter/foundation.dart';
import 'dart:async';

class UniversalTimer extends ChangeNotifier {
  // Singleton instance
  static final UniversalTimer _instance = UniversalTimer._internal();
  factory UniversalTimer() => _instance;
  UniversalTimer._internal();

  // Store individual timers for each line
  final Map<String, TimerService> _timers = {};

  TimerService getTimerForLine(String lineId) {
    return _timers.putIfAbsent(lineId, () => TimerService(this));
  }
}

class TimerService {
  final UniversalTimer _notifier;
  Timer? _timer;
  int _secondsElapsed = 0;
  bool _isRunning = false;

  // Add a ValueNotifier to track elapsed time
  ValueNotifier<int> elapsedTimeNotifier = ValueNotifier<int>(0);

  TimerService(this._notifier);

  bool get isRunning => _isRunning;
  int get secondsElapsed => _secondsElapsed;

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _secondsElapsed++;
      elapsedTimeNotifier.value = _secondsElapsed; // Update elapsedTimeNotifier
      _notifier.notifyListeners(); // Notify listeners on every tick
    });
  }

  void stop() {
    if (_isRunning) {
      _timer?.cancel();
      _isRunning = false;
      _notifier.notifyListeners(); // Notify listeners when stopped
    }
  }

  void reset() {
    stop();
    _secondsElapsed = 0;
    elapsedTimeNotifier.value = _secondsElapsed; // Reset elapsedTimeNotifier
    _notifier.notifyListeners(); // Notify listeners after reset
  }

  void resetAndStart() {
    reset();
    start();
  }

  // Method to manually set the elapsed time
  void setElapsedTime(int seconds) {
    _secondsElapsed = seconds;
    elapsedTimeNotifier.value = _secondsElapsed; // Update elapsedTimeNotifier
    _notifier.notifyListeners(); // Notify listeners about the update
  }
}
