import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/material.dart';
import 'package:gmc/LoginPages/login_page.dart';

import 'package:gmc/MainComponants/reusable_black_textfield.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:gmc/myutility.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _profileEmailController = TextEditingController();
  final TextEditingController _profileCurrentPasswordController =
      TextEditingController();
  final TextEditingController _profileNumberController =
      TextEditingController();
  final TextEditingController _profileNameController = TextEditingController();

  // Logout function
  void _logoutUser() async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out the current user
      print("User successfully logged out.");

      // Navigate back to the LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    } catch (e) {
      print("Error logging out: $e");
      // Optionally show an error dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Logout Failed'),
            content:
                Text('An error occurred while logging out. Please try again.'),
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: MyUtility(context).width,
        height: MyUtility(context).height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                      "images/GMC_Logo_White_Background_Black_Text 1.png"),
                ],
              ),
              Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    height: MyUtility(context).height * 0.8,
                    width: MyUtility(context).width * 0.9,
                    decoration: BoxDecoration(
                      color: GMCColors.lightGrey,
                      borderRadius: BorderRadius.circular((12.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(0, -4),
                          blurRadius: 4.0,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(4, 0),
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10.0),
                      child: Column(
                        children: [
                          BlackTextField(
                              title: 'Name',
                              controller: _profileNameController),
                          const SizedBox(height: 20),
                          BlackTextField(
                              title: 'Contact Number',
                              controller: _profileNumberController),
                          const SizedBox(height: 20),
                          BlackTextField(
                              title: 'Email',
                              controller: _profileEmailController),
                          const SizedBox(height: 20),
                          BlackTextField(
                              title: 'Current Password',
                              controller: _profileCurrentPasswordController),
                          const SizedBox(height: 30),
                          // Add Logout Button
                          ElevatedButton(
                            onPressed: _logoutUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: GMCColors.darkBlue,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 30.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Logout',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
