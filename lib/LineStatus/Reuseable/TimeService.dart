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
    if (_isRunning) return; // Prevent multiple timers from starting

    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsElapsed++;
      elapsedTimeNotifier.value = _secondsElapsed; // Update the notifier value
      notifyListeners(); // Notify listeners on each tick

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
    }
  }

  void resetAndStartTimer(String documentId) {
    _timer?.cancel(); //stopes time running
    _secondsElapsed = 0; // Reset time
    _isRunning = true;
    elapsedTimeNotifier.value = _secondsElapsed;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsElapsed++;
      elapsedTimeNotifier.value = _secondsElapsed;
      notifyListeners();

      // Add supervisor if timer reaches 60 seconds
      if (_secondsElapsed == 60) {
        _addSupervisorToDownedLines(documentId);
      }
    });
  }

  void resetTimer() {
    _timer?.cancel(); // Stop any running timer
    _timer = null; // Set timer reference to null
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
          print('Supervisor added to DownedLines for line: $documentId');
        } else {
          print('No unresolved DownedLines found for line: $documentId');
        }
      } else {
        print('No supervisor found in the users collection.');
      }
    } catch (error) {
      print('Error adding supervisor to DownedLines: $error');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
