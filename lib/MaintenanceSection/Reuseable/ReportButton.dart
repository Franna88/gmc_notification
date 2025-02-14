import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ReportButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF242728),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
        ),
        child: Text(
          'Report',
          style: GoogleFonts.roboto(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFF6A707),
          ),
        ),
      ),
    );
  }
}
