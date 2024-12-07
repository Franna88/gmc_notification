import 'package:flutter/material.dart';
import 'package:gmc/Themes/gmc_colors.dart';

class GroupButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final bool centerText; // Added conditional parameter

  const GroupButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.centerText = false, // Default is false
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: -4,
            right: -4,
            child: Container(
              decoration: BoxDecoration(
                color: GMCColors.orange,
                borderRadius: BorderRadius.circular(12.0),
              ),
              width: 145,
              height: 50,
            ),
          ),
          Container(
            width: 145,
            decoration: BoxDecoration(
              color: GMCColors.darkGrey,
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            alignment: centerText
                ? Alignment.center
                : Alignment.centerLeft, // Conditionally center text
            child: Text(
              buttonText,
              style: const TextStyle(
                color: GMCColors.orange,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
