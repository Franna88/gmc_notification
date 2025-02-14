import 'package:flutter/material.dart';
import 'package:gmc/myutility.dart';
import 'package:google_fonts/google_fonts.dart';

class LineSectionContainer extends StatefulWidget {
  final String leftText;
  final String rightText;

  const LineSectionContainer({
    super.key,
    required this.leftText,
    required this.rightText,
  });

  @override
  State<LineSectionContainer> createState() => _LineSectionContainerState();
}

class _LineSectionContainerState extends State<LineSectionContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 20),
      child: Container(
        width: MyUtility(context).width,
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFFF68D2B),
          border: Border.all(color: Colors.black),
        ),
        child: Stack(
          children: [
            // Left-aligned text
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  widget.leftText,
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            // Right-aligned text
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  widget.rightText,
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
