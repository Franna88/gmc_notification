import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:gmc/LineStatus/Reuseable/Notifications.dart';

class UniversalTimer extends ChangeNotifier {
  // Singleton instance
  static final UniversalTimer _instance = UniversalTimer._internal();
  factory UniversalTimer() => _instance;
  UniversalTimer._internal();

  // Store individual timers for each line
  final Map<String, NewTimeService> _timers = {};

  NewTimeService getTimerForLine(String lineId) {
    debugPrint('Fetching NewTimeService for lineId: $lineId');
    return _timers.putIfAbsent(lineId, () {
      debugPrint('Creating new NewTimeService for lineId: $lineId');
      return NewTimeService(this, lineId);
    });
  }
}

class NewTimeService {
  final UniversalTimer _notifier;
  final String _lineId; // Store the line ID
  Timer? _timer;
  int _secondsElapsed = 0;
  bool _isRunning = false;

  // Add a ValueNotifier to track elapsed time
  ValueNotifier<int> elapsedTimeNotifier = ValueNotifier<int>(0);

  NewTimeService(this._notifier, this._lineId);

  bool get isRunning => _isRunning;
  int get secondsElapsed => _secondsElapsed;

  void start() async {
    if (_isRunning) return;
    _isRunning = true;

    // Send notifications to technicians as the line goes offline
    await notifyTechnicians();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      _secondsElapsed++;
      elapsedTimeNotifier.value = _secondsElapsed;
      _notifier.notifyListeners();
      debugPrint(
          'Timer tick: $_secondsElapsed seconds for line $_lineId'); // Debug log

      // Check if elapsed time has reached the threshold for supervisor addition
      if (_secondsElapsed == 30) {
        // Adjust this value for the required delay
        await addSupervisorDetails();
      }
    });
    debugPrint('Timer started for line $_lineId'); // Debug log
  }

  void stop() {
    if (_isRunning) {
      _timer?.cancel();
      _isRunning = false;
      _notifier.notifyListeners();
      debugPrint(
          'Timer stopped at $_secondsElapsed seconds for line $_lineId'); // Debug log
    }
  }

  Future<void> notifyTechnicians() async {
    try {
      debugPrint('Fetching technician details for notifications');

      // Fetch all users with the role of 'technician'
      var techniciansSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'technician')
          .get();

      var lineSnaphot = await FirebaseFirestore.instance
          .collection('systems')
          .doc(_lineId)
          .get();
      String message = "Production Line ${_lineId} has gone offline.";
      Map<String, dynamic> data = lineSnaphot.data() as Map<String, dynamic>;
      if (data.containsKey('message')) {
        message = lineSnaphot.get('message');
      } else {
        print('Message key does not exist.');
      }

      if (techniciansSnapshot.docs.isNotEmpty) {
        // Initialize NotificationService and ensure credentials are loaded
        final notificationService = NotificationService();
        await notificationService.initialize();

        for (var doc in techniciansSnapshot.docs) {
          var technicianData = doc.data();
          var technicianToken = technicianData['fcmToken']; // FCM token field
          var technicianName = technicianData['name'] ?? 'Technician';

          if (technicianToken != null) {
            // Send notification to the technician
            await notificationService.sendNotification(
              token: technicianToken,
              title: 'Line Offline: $_lineId',
              body: message,
            );
            debugPrint(
                'Notification sent to $technicianName for line $_lineId');
          } else {
            debugPrint(
                'No FCM token available for technician: $technicianName');
          }
        }
      } else {
        debugPrint('No technicians found in users collection.');
      }
    } catch (e) {
      debugPrint(
          'Error sending notifications to technicians for line $_lineId: $e');
    }
  }

  Future<void> addSupervisorDetails() async {
    try {
      debugPrint('Fetching supervisor details for line $_lineId');

      // Fetch the supervisor details
      var userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'supervisor')
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        var supervisorData = userSnapshot.docs.first.data();
        var supervisorId = userSnapshot.docs.first.id; // Supervisor's UUID
        var supervisorName = supervisorData['name'] ?? 'Unknown';
        var supervisorToken = supervisorData['fcmToken']; // FCM token field

        debugPrint(
            'Supervisor found: $supervisorName with UUID: $supervisorId for line $_lineId');

        // Query the most recent downedLines document
        var downedLinesSnapshot = await FirebaseFirestore.instance
            .collection('downedLines')
            .where('lineId', isEqualTo: _lineId)
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (downedLinesSnapshot.docs.isNotEmpty) {
          var downedLineDocRef = downedLinesSnapshot.docs.first.reference;

          // Update the document with supervisor details
          await downedLineDocRef.update({
            'supervisorId': supervisorId,
            'supervisorName': supervisorName,
          });

          debugPrint(
              'Supervisor details added to downedLines for line $_lineId');

          // Send a push notification to the supervisor
          if (supervisorToken != null) {
            // Initialize NotificationService (ensure credentials are loaded once)
            final notificationService = NotificationService();
            await notificationService.initialize();

            await notificationService.sendNotification(
              token: supervisorToken,
              title: 'Line Down Alert: $_lineId',
              body: 'Supervisor $supervisorName has been assigned to $_lineId.',
            );
          } else {
            debugPrint(
                'No FCM token available for supervisor with UUID: $supervisorId');
          }
        } else {
          debugPrint(
              'No matching document found in downedLines for line $_lineId');
        }
      } else {
        debugPrint('No supervisor found in users collection.');
      }
    } catch (e) {
      debugPrint(
          'Error adding supervisor to downedLines for line $_lineId: $e');
    }
  }

  Future<void> storeElapsedTime() async {
    try {
      if (_secondsElapsed > 0) {
        debugPrint(
            'Updating totalDownTime for line $_lineId in downedLines collection: $_secondsElapsed seconds');

        // Query the specific document in downedLines with the most recent timestamp
        var querySnapshot = await FirebaseFirestore.instance
            .collection('downedLines')
            .where('lineId', isEqualTo: _lineId)
            .where('status', isEqualTo: 'attending') // Or the correct status
            .orderBy('timestamp', descending: true) // Ensure most recent event
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Update the first matched document
          var docRef = querySnapshot.docs.first.reference;

          await docRef.update({
            'totalDownTime': _secondsElapsed,
            'status': 'resolved',
          });

          debugPrint(
              'Elapsed time successfully updated in downedLines for line $_lineId');
        } else {
          debugPrint(
              'No matching document found in downedLines for line $_lineId');
        }
      } else {
        debugPrint('Elapsed time is 0; nothing to store for line $_lineId');
      }
    } catch (e) {
      debugPrint(
          'Error updating elapsed time in downedLines for line $_lineId: $e');
    }
  }

  Future<void> reset() async {
    if (_secondsElapsed > 0) {
      debugPrint(
          'Attempting to store elapsed time before reset for line $_lineId');
      await storeElapsedTime(); // Always try to store elapsed time
    } else {
      debugPrint('Elapsed time is 0; nothing to store for line $_lineId');
    }

    stop(); // Stop the timer
    _secondsElapsed = 0;
    elapsedTimeNotifier.value = _secondsElapsed; // Reset elapsedTimeNotifier
    _notifier.notifyListeners(); // Notify listeners after reset
    debugPrint('Timer reset to 0 for line $_lineId'); // Debug log
  }

  void resetAndStart() async {
    debugPrint('Reset and start called for line $_lineId');
    await reset();
    start();
  }

  // Method to manually set the elapsed time
  void setElapsedTime(int seconds) {
    if (_secondsElapsed != seconds) {
      debugPrint(
          'Updating elapsed time for NewTimeService: $_secondsElapsed -> $seconds for line $_lineId');
      _secondsElapsed = seconds;
      elapsedTimeNotifier.value = _secondsElapsed; // Update elapsedTimeNotifier
      _notifier.notifyListeners(); // Notify listeners about the update
    }
  }
}
