import 'package:flutter/material.dart';
import 'package:gmc/LoginPages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Material(color: Colors.white, child: LoginPage()));
  }
}
