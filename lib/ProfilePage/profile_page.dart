import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
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
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: MyUtility(context).height * 0.8,
                    width: MyUtility(context).width * 0.9,
                    decoration: BoxDecoration(
                        color: GMCColors.lightGrey,
                        borderRadius: BorderRadius.circular(12)),
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
