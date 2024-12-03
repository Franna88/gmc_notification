import 'package:flutter/material.dart';

import 'package:gmc/Themes/gmc_colors.dart'; // Import the file where GMCColors is defined.

class TextStyles {
  BuildContext context;
  TextStyles(this.context);

  double get width => MediaQuery.of(context).size.width;

  // Large heading style
  TextStyle get headingLarge => TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: width / 16, // Adjust based on screen width
        color: GMCColors.darkGrey, // Set the color
      );

  // Medium heading style
  TextStyle get headingMedium => TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w600,
        fontSize: width / 25, // Adjust based on screen width
        color: GMCColors.darkGrey, // Set the color
      );

  // Regular body text style
  TextStyle get bodyText => TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.normal,
        fontSize: width / 31, // Adjust based on screen width
        color: GMCColors.darkGrey, // Set the color
      );

  // Small body text style
  TextStyle get bodySmall => TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.normal,
        fontSize: width / 38, // Adjust based on screen width
        color: GMCColors.darkGrey, // Set the color
      );

  // Italic style
  TextStyle get italic => TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.normal,
        fontSize: width / 31, // Adjust based on screen width
        fontStyle: FontStyle.italic,
        color: GMCColors.darkGrey, // Set the color
      );

  // Bold text style
  TextStyle get bold => TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: width / 31, // Adjust based on screen width
        color: GMCColors.darkGrey, // Set the color
      );

  // Light text style
  TextStyle get light => TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w300,
        fontSize: width / 31, // Adjust based on screen width
        color: GMCColors.darkGrey, // Set the color
      );
}
