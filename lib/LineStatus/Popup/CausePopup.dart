import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gmc/LineStatus/Reuseable/PopupButton.dart';
import 'package:gmc/Themes/gmc_colors.dart';

class CausePopup extends StatefulWidget {
  const CausePopup({super.key});

  @override
  State<CausePopup> createState() => _CausePopupState();
}

class _CausePopupState extends State<CausePopup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
          horizontal: 15.0), // Only a small gap at the sides
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Container(
        width: double.infinity, // Expand to full width minus insetPadding
        height: MediaQuery.of(context).size.height *
            0.95, // Cover 95% of the screen height
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
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SvgPicture.asset('images/popback.svg'),
                  ),
                  Text(
                    'CAUSE',
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
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(6.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Describe the issue:',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        height: 260,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: GMCColors.darkGrey,
                          ),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          maxLines: 12,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Enter the description here...',
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),

                      Text(
                        'Add an Image of the issue:',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 240,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: GMCColors.darkGrey,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.camera_alt,
                              size: 50.0,
                              color: GMCColors.darkGrey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      // Submit Button
                      Center(
                        child: PopupButton(
                          onTap: () {},
                          buttonColor: GMCColors.orange,
                          buttonText: "Submit",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
