import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

class NotificationService {
  static const String _fcmEndpoint =
      'https://fcm.googleapis.com/v1/projects/gmc-95f76/messages:send';

  late final ServiceAccountCredentials _credentials;
  bool _credentialsInitialized = false;

  NotificationService();

  Future<void> initialize() async {
    if (!_credentialsInitialized) {
      try {
        debugPrint('Attempting to load service account credentials...');
        try {
          // Load the JSON file from assets
          final jsonString =
              await rootBundle.loadString('assets/keys/serviceAccountKey.json');
          _credentials = ServiceAccountCredentials.fromJson(jsonString);
          debugPrint(
              'Service account credentials loaded successfully from assets.');
        } catch (e) {
          debugPrint(
              'Error loading asset file. Falling back to absolute path...');
          // Absolute path fallback
          final filePath =
              'C:/Users/27834/OneDrive/Desktop/GMC/gmc/assets/keys/serviceAccountKey.json';
          final jsonString = await File(filePath).readAsString();
          _credentials = ServiceAccountCredentials.fromJson(jsonString);
          debugPrint(
              'Service account credentials loaded successfully from absolute path.');
        }

        _credentialsInitialized = true;
      } catch (e) {
        debugPrint('Error initializing service account credentials: $e');
        rethrow;
      }
    }
  }

  Future<AccessCredentials> _getAccessToken() async {
    if (!_credentialsInitialized) {
      throw Exception(
          "Service account credentials have not been initialized. Call 'initialize()' first.");
    }

    final authClient = await clientViaServiceAccount(
        _credentials, ['https://www.googleapis.com/auth/cloud-platform']);
    return authClient.credentials;
  }

  // Send notification to a single user and return the response
  Future<http.Response> sendNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    try {
      if (!_credentialsInitialized) {
        throw Exception(
            "Service account credentials have not been initialized. Call 'initialize()' first.");
      }

      final accessToken = (await _getAccessToken()).accessToken.data;

      var response = await http.post(
        Uri.parse(_fcmEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'message': {
            'token': token,
            'notification': {
              'title': title,
              'body': body,
            },
          },
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('Push notification sent successfully');
      } else {
        debugPrint(
            'Failed to send push notification. Status: ${response.statusCode}, Body: ${response.body}');
      }
      return response; // Return the HTTP response
    } catch (e) {
      debugPrint('Error sending push notification: $e');
      rethrow; // Allow the calling function to handle the exception
    }
  }

  // Send notifications to multiple users and return a list of responses
  Future<List<http.Response>> sendNotificationsToMultiple({
    required List<String> tokens,
    required String title,
    required String body,
  }) async {
    List<http.Response> responses = [];
    for (var token in tokens) {
      try {
        var response =
            await sendNotification(token: token, title: title, body: body);
        responses.add(response);
      } catch (e) {
        debugPrint('Failed to send notification to token: $token. Error: $e');
      }
    }
    return responses; // Return the list of HTTP responses
  }

  static NotificationService fromJson(String jsonString) {
    final service = NotificationService();
    service._credentials = ServiceAccountCredentials.fromJson(jsonString);
    service._credentialsInitialized = true;
    return service;
  }
}
