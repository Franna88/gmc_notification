import 'package:flutter/material.dart';
import 'package:gmc/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:gmc/api/firebase-api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      // Initialize Firebase for web
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyDLq-iNSUPe1zlVI-6gdD1eqogjan5UhN4",
          authDomain: "gmc-95f76.firebaseapp.com",
          projectId: "gmc-95f76",
          storageBucket: "gmc-95f76.firebasestorage.app",
          messagingSenderId: "495285712978",
          appId: "1:495285712978:web:739f64ebb49e9d5abac78b",
        ),
      );
    } else {
      // Initialize Firebase for mobile
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyDLq-iNSUPe1zlVI-6gdD1eqogjan5UhN4",
          authDomain: "gmc-95f76.firebaseapp.com",
          projectId: "gmc-95f76",
          storageBucket: "gmc-95f76.firebasestorage.app",
          messagingSenderId: "495285712978",
          appId: "1:495285712978:web:739f64ebb49e9d5abac78b",
        ),
      );
      await FirebaseApi().initNotifications();
    }
    print("Firebase initialized successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GMC Notifications',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
