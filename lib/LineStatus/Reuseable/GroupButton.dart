import 'package:flutter/material.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:google_fonts/google_fonts.dart';

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
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: GMCColors.darkGrey,
          borderRadius: BorderRadius.circular(6.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        alignment: centerText
            ? Alignment.center
            : Alignment.centerLeft, // Conditionally center text
        child: Text(
          buttonText,
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 17.0,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
