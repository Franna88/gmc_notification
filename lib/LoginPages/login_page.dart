import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:gmc/LineStatus/Reuseable/GroupButton.dart';
import 'package:gmc/MainComponants/reusable_black_textfield.dart';
import 'package:gmc/MobileNavBar/MobileNavBar.dart';
import 'package:gmc/myutility.dart';
import 'diagonal_painter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp(); // Initialize Firebase
      _checkIfLoggedIn(); // Check if user is already logged in
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }

  Future<void> _saveFCMToken(String userId) async {
    try {
      String? token =
          await FirebaseMessaging.instance.getToken(); // Get the FCM token
      if (token != null) {
        // Save the token to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'fcmToken': token,
        });
        print('FCM Token saved for user $userId: $token');
      } else {
        print('Failed to retrieve FCM token');
      }
    } catch (e) {
      print('Error saving FCM token: $e');
    }
  }

  void _listenForTokenRefresh(String userId) {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      try {
        // Update the token in Firestore when it changes
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'fcmToken': newToken,
        });
        print('FCM Token updated for user $userId: $newToken');
      } catch (e) {
        print('Error updating FCM token: $e');
      }
    });
  }

  void _checkIfLoggedIn() {
    User? user = _auth.currentUser;
    if (user != null) {
      print("User already logged in, navigating to MobileNavBar.");
      _saveFCMToken(user.uid); // Save FCM token for already logged-in user
      _listenForTokenRefresh(user.uid); // Listen for token refresh
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MobileNavBar(),
        ),
      );
    } else {
      print("No user is currently logged in.");
    }
  }

  void _loginUser() async {
    String email = _loginEmailController.text.trim();
    String password = _loginPasswordController.text.trim();

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      print("Login successful for user: $userId");

      // Save FCM token and listen for token refresh
      await _saveFCMToken(userId);
      _listenForTokenRefresh(userId);

      // Navigate to the main app page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MobileNavBar(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      String errorMessage;

      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = 'An error occurred. Please try again later.';
      }

      // Show an alert dialog with the error message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            print("User is logged in with UID: ${snapshot.data?.uid}");
            return const MobileNavBar();
          }

          return Stack(
            children: [
              CustomPaint(
                size: Size(MyUtility(context).width, MyUtility(context).height),
                painter: DiagonalPainter(),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/Antolin.png',
                          width: MyUtility(context).width * 0.75,
                          height: MyUtility(context).height * 0.35,
                        ),
                        const SizedBox(height: 50),
                        BlackTextField(
                          title: 'Username',
                          controller: _loginEmailController,
                          width: MyUtility(context).width * 0.77,
                        ),
                        const SizedBox(height: 20),
                        BlackTextField(
                          title: 'Password',
                          controller: _loginPasswordController,
                          obscureText: true,
                          width: MyUtility(context).width * 0.77,
                        ),
                        SizedBox(
                          width: MyUtility(context).width * 0.79,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Add forgot password functionality
                              },
                              child: const Text(
                                'Forgot Password ?',
                                style: TextStyle(
                                  color: Color(0xFF001E64),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: MyUtility(context).height * 0.1),
                        GroupButton(
                          buttonText: 'LOGIN',
                          onTap: _loginUser,
                          centerText: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
