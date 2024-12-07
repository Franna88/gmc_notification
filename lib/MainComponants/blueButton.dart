// reusable_blue_button.dart
import 'package:flutter/material.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:gmc/myutility.dart';

class BlueButton extends StatelessWidget {
  final String text;
  final double? width;
  final VoidCallback onPressed;

  const BlueButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MyUtility(context).width * 0.3,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: GMCColors.darkTeal, // Button color
          textStyle: const TextStyle(color: Colors.white), // Text color
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white, // Text color
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
