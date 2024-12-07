import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class TimerService extends ChangeNotifier {
  Timer? _timer;
  int _secondsElapsed = 0;
  bool _isRunning = false;

  // Notifier to track the elapsed time and notify listeners
  ValueNotifier<int> elapsedTimeNotifier = ValueNotifier<int>(0);

  bool get isRunning => _isRunning;
  int get secondsElapsed => _secondsElapsed;

  void startTimer(String documentId) {
    if (_isRunning) {
      debugPrint('Timer for $documentId is already running.');
      return; // Prevent multiple timers from starting
    }

    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsElapsed++;
      elapsedTimeNotifier.value = _secondsElapsed; // Update the notifier value
      notifyListeners(); // Notify listeners on each tick

      debugPrint('Timer running: $_secondsElapsed seconds');

      // Add supervisor if timer reaches 60 seconds
      if (_secondsElapsed == 60) {
        _addSupervisorToDownedLines(documentId);
      }
    });
  }

  void stopTimer() {
    if (_isRunning) {
      _timer?.cancel();
      _isRunning = false;
      notifyListeners();
      debugPrint('Timer stopped at $_secondsElapsed seconds');
    }
  }

  void resetAndStartTimer(String documentId) {
    debugPrint('Resetting and starting timer for $documentId');
    _timer?.cancel(); // Stops timer if running
    _secondsElapsed = 0; // Reset elapsed time
    elapsedTimeNotifier.value = _secondsElapsed; // Update notifier
    notifyListeners();

    startTimer(documentId); // Start the timer after resetting
  }

  void resetTimer() {
    debugPrint('Resetting timer.');
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _secondsElapsed = 0; // Reset elapsed time to zero
    elapsedTimeNotifier.value = _secondsElapsed; // Reset the notifier value
    notifyListeners(); // Notify listeners about the reset
  }

  Future<void> _addSupervisorToDownedLines(String documentId) async {
    final downedLinesRef = FirebaseFirestore.instance.collection('downedLines');
    final usersRef = FirebaseFirestore.instance.collection('users');

    try {
      // Fetch the supervisor user
      final supervisorSnapshot =
          await usersRef.where('role', isEqualTo: 'supervisor').limit(1).get();

      if (supervisorSnapshot.docs.isNotEmpty) {
        final supervisor = supervisorSnapshot.docs.first;

        // Update the DownedLines collection
        final downedLineQuery = await downedLinesRef
            .where('lineId', isEqualTo: documentId)
            .where('status', isEqualTo: 'attending')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (downedLineQuery.docs.isNotEmpty) {
          final downedLineDoc = downedLineQuery.docs.first;
          await downedLineDoc.reference.update({
            'supervisorId': supervisor.id,
            'notificationTimestamps': FieldValue.arrayUnion(
              [FieldValue.serverTimestamp()],
            ),
          });
          debugPrint('Supervisor added to DownedLines for line: $documentId');
        } else {
          debugPrint('No unresolved DownedLines found for line: $documentId');
        }
      } else {
        debugPrint('No supervisor found in the users collection.');
      }
    } catch (error) {
      debugPrint('Error adding supervisor to DownedLines: $error');
    }
  }

  @override
  void dispose() {
    debugPrint('Disposing TimerService.');
    _timer?.cancel();
    super.dispose();
  }
}
