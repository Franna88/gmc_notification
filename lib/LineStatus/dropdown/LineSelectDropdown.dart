import 'package:flutter/material.dart';
import 'package:gmc/myutility.dart';
import 'package:google_fonts/google_fonts.dart';

class LineSelectDropdown extends StatefulWidget {
  final List<String> lines;
  final Function(String) onLineSelected;
  final String selectedLine;

  const LineSelectDropdown({
    super.key,
    required this.lines,
    required this.onLineSelected,
    required this.selectedLine,
  });

  @override
  State<LineSelectDropdown> createState() => _LineSelectDropdownState();
}

class _LineSelectDropdownState extends State<LineSelectDropdown> {
  bool _isDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      onSelected: (String value) {
        widget.onLineSelected(value);
      },
      itemBuilder: (BuildContext context) {
        return widget.lines.map((String line) {
          return PopupMenuItem<String>(
            value: line,
            child: Text(
              line,
              style: GoogleFonts.roboto(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        }).toList();
      },
      child: Container(
        width: MyUtility(context).width,
        height: MyUtility(context).height * 0.09,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(6.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFF25CFA2),
                  width: 2.5,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: SizedBox(
                width: 45.0,
                height: 72.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    3,
                    (index) => Container(
                      height: 10.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFF37414A),
                        border: Border.all(
                          color: const Color(0xFF25CFA2),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Lines',
                  style: GoogleFonts.roboto(
                    color: const Color(0xFF25CFA2),
                    fontSize: 24.0,
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
