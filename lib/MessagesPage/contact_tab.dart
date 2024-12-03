import 'package:flutter/material.dart';
import 'package:gmc/MessagesPage/reusable_contact_containers.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:gmc/myutility.dart';

class ContactTab extends StatelessWidget {
  const ContactTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MyUtility(context).height * 0.8,
      width: MyUtility(context).width * 0.9,
      decoration: const BoxDecoration(
        color: GMCColors.lightGrey,
      ),
      child: const Column(
        children: [
          SizedBox(height: 16), // Space between the sections
          ReusableContactContainers(
              title: 'User Name',
              dateTime: '03/05/2015',
              description: 'This is a description text for a message.')
        ],
      ),
    );
  }
}
