import 'package:gmc/LineStatus/Reuseable/TimeService.dart';

class TimerServiceManager {
  static final TimerServiceManager _instance = TimerServiceManager._internal();
  factory TimerServiceManager() => _instance;

  TimerServiceManager._internal();

  // Store TimerService instances for each line by their document ID
  final Map<String, TimerService> _timerServices = {};

  // Method to get or create a TimerService instance for a given line ID
  TimerService getServiceForLine(String lineId) {
    if (!_timerServices.containsKey(lineId)) {
      _timerServices[lineId] = TimerService();
    }
    return _timerServices[lineId]!;
  }

  // Method to reset a TimerService instance for a given line ID
  void resetServiceForLine(String lineId) {
    if (_timerServices.containsKey(lineId)) {
      _timerServices[lineId]!.resetTimer();
    }
  }
}
