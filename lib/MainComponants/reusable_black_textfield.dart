import 'package:flutter/material.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:gmc/Themes/text_styles.dart';

class BlackTextField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final double? width; // Optional width property

  const BlackTextField({
    super.key,
    required this.title,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.width, // Optional parameter for width
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles(context).headingMedium,
        ),
        const SizedBox(height: 8), // Space between title and text field
        SizedBox(
          width: width, // Apply width if provided
          height: 45, // Fixed height
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: const TextStyle(color: GMCColors.white),
            decoration: const InputDecoration(
              filled: true,
              fillColor: GMCColors.darkGrey,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: GMCColors.darkGrey),
                borderRadius:
                    BorderRadius.all(Radius.circular(6)), // Border radius
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: GMCColors.darkGrey),
                borderRadius:
                    BorderRadius.all(Radius.circular(6)), // Border radius
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: GMCColors.darkGrey),
                borderRadius:
                    BorderRadius.all(Radius.circular(6)), // Border radius
              ),
            ),
          ),
        ),
      ],
    );
  }
}
