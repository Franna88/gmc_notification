import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MaintenanceFaultContainer extends StatefulWidget {
  final String faultLocation;
  final String faultCause;
  final Widget image;

  const MaintenanceFaultContainer({
    super.key,
    required this.faultLocation,
    required this.faultCause,
    required this.image,
  });

  @override
  State<MaintenanceFaultContainer> createState() =>
      _MaintenanceFaultContainerState();
}

class _MaintenanceFaultContainerState extends State<MaintenanceFaultContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF37414A),
            width: 1,
          ),
          color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: const Color(0xFF242728),
            width: double.infinity,
            child: Text(
              widget.faultLocation,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFF6A707),
              ),
            ),
          ),

          // Image section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: widget.image,
          ),

          // Button section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF3D3B3C),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text.rich(
                TextSpan(
                  children: _formatFaultCauseText(widget.faultCause),
                ),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _formatFaultCauseText(String text) {
    final words = text.split(' ');
    if (words.length <= 2) return [TextSpan(text: text)];

    final firstTwoWords = words.take(2).join(' ');
    final remainingWords = words.skip(2).join(' ');

    return [
      TextSpan(text: firstTwoWords),
      TextSpan(text: '\n${remainingWords}'),
    ];
  }
}
