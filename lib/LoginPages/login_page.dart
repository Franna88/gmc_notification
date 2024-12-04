import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'images/GMC_Logo_White_Background_Black_Text 1.png',
              width: MyUtility(context).width * 0.4,
              height: MyUtility(context).height * 0.4,
            ),
            const SizedBox(height: 20),
            BlackTextField(title: 'Email', controller: _loginEmailController),
            const SizedBox(height: 10),
            BlackTextField(
                title: 'Password Desktop',
                controller: _loginPasswordController),
            Spacer(),
            GroupButton(
              buttonText: 'Login',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MobileNavBar(),
                  ),
                );
              },
              centerText: true,
            )
          ],
        ),
      ),
    );
  }
}
