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
    debugPrint('Fetching TimerService for lineId: $lineId');
    return _timers.putIfAbsent(lineId, () {
      debugPrint('Creating new TimerService for lineId: $lineId');
      return TimerService(this);
    });
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
      elapsedTimeNotifier.value = _secondsElapsed;
      _notifier.notifyListeners();
      debugPrint('Timer tick: $_secondsElapsed seconds'); // Debug log
    });
    debugPrint('Timer started'); // Debug log
  }

  void stop() {
    if (_isRunning) {
      _timer?.cancel();
      _isRunning = false;
      _notifier.notifyListeners();
      debugPrint('Timer stopped at $_secondsElapsed seconds'); // Debug log
    }
  }

  void reset() {
    stop();
    _secondsElapsed = 0;
    elapsedTimeNotifier.value = _secondsElapsed; // Reset elapsedTimeNotifier
    _notifier.notifyListeners(); // Notify listeners after reset
    debugPrint('Timer reset to 0'); // Debug log
  }

  void resetAndStart() {
    reset();
    start();
  }

  // Method to manually set the elapsed time
  void setElapsedTime(int seconds) {
    if (_secondsElapsed != seconds) {
      debugPrint(
          'Updating elapsed time for TimerService: $_secondsElapsed -> $seconds');
      _secondsElapsed = seconds;
      elapsedTimeNotifier.value = _secondsElapsed; // Update elapsedTimeNotifier
      _notifier.notifyListeners(); // Notify listeners about the update
    }
  }
}
