import 'package:flutter/material.dart';
import 'package:gmc/LoginPages/login_page.dart';

import 'package:gmc/MobileNavBar/MobileNavBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Material(
      color: Colors.white,
      child: Scaffold(
        body:
            // MobileNavBar(),
            LoginPage(),
      ),
    );
  }
}
