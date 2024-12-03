import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gmc/LineStatus/Reuseable/PopupButton.dart';
import 'package:gmc/Themes/gmc_colors.dart';

class AttendingPopup extends StatefulWidget {
  const AttendingPopup({super.key});

  @override
  State<AttendingPopup> createState() => _AttendingPopupState();
}

class _AttendingPopupState extends State<AttendingPopup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: GMCColors.darkGrey,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(6.0),
              ),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SvgPicture.asset('images/popback.svg')),
                Text(
                  'ATTEND',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: GMCColors.orange,
                  ),
                ),
                SizedBox(width: 24.0),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(6.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16.0),
                // Message
                Text(
                  '"User Name" you will be attending to this issue?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 24.0),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PopupButton(
                      onTap: () {},
                      buttonColor: GMCColors.orange,
                      buttonText: "Accept",
                    ),
                    PopupButton(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      buttonColor: GMCColors.red,
                      buttonText: "Cancel",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
