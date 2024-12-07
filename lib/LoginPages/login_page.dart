import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:gmc/LineStatus/Reuseable/GroupButton.dart';
import 'package:gmc/MainComponants/reusable_black_textfield.dart';
import 'package:gmc/MobileNavBar/MobileNavBar.dart';
import 'package:gmc/myutility.dart';

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
      await Firebase.initializeApp(); // Ensure Firebase is initialized properly
      _checkIfLoggedIn(); // Check if user is already logged in after Firebase initialization
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }

  void _checkIfLoggedIn() {
    User? user = _auth.currentUser;
    if (user != null) {
      // User is already logged in, navigate to the main page
      print("User already logged in, navigating to MobileNavBar.");
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
      // Attempt to sign in the user with Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("Login successful for user: ${userCredential.user?.uid}");

      // If successful, navigate to the main app page
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
            // User is logged in, redirect to the main page
            print("User is logged in with UID: ${snapshot.data?.uid}");
            return const MobileNavBar();
          }

          // User is not logged in, show the login page
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/GMC_Logo_White_Background_Black_Text 1.png',
                      width: MyUtility(context).width * 0.4,
                      height: MyUtility(context).height * 0.3,
                    ),
                    const SizedBox(height: 20),
                    BlackTextField(
                      title: 'Email',
                      controller: _loginEmailController,
                    ),
                    const SizedBox(height: 10),
                    BlackTextField(
                      title: 'Password',
                      controller: _loginPasswordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),
                    GroupButton(
                      buttonText: 'Login',
                      onTap: _loginUser,
                      centerText: true,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
