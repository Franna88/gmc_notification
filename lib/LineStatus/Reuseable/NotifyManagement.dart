import 'package:flutter/material.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:gmc/myutility.dart';

class NotifyManagement extends StatefulWidget {
  final bool isNotified;
  const NotifyManagement({super.key, required this.isNotified});

  @override
  State<NotifyManagement> createState() => _NotifyManagementState();
}

class _NotifyManagementState extends State<NotifyManagement> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isNotified, // Controls visibility based on `isNotified`
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: MyUtility(context).width,
          decoration: BoxDecoration(
            color: GMCColors.darkTeal,
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alert',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: GMCColors.darkRed,
                  ),
                ),
                Text(
                  '15 Minutes have passed, Management Notified',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: GMCColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
