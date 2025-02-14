import 'package:flutter/material.dart';
import 'package:gmc/myutility.dart';
import 'package:google_fonts/google_fonts.dart';

class MaintancenceinProgress extends StatefulWidget {
  final String sectionNumber;
  final String sectionName;

  const MaintancenceinProgress({
    super.key,
    required this.sectionNumber,
    required this.sectionName,
  });

  @override
  State<MaintancenceinProgress> createState() => _MaintancenceinProgressState();
}

class _MaintancenceinProgressState extends State<MaintancenceinProgress> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
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
                  widget.sectionNumber,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            // Center dash
            const Center(
              child: Text(
                "-",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Right-aligned text
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  widget.sectionName,
                  style: GoogleFonts.inter(
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
