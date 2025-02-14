import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabSelector extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final List<String> tabLabels;

  const TabSelector({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.tabLabels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: tabLabels.asMap().entries.map((entry) {
            final index = entry.key;
            final label = entry.value;
            return InkWell(
              onTap: () => onTabSelected(index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  gradient: selectedIndex == index
                      ? LinearGradient(
                          colors: [
                            Color(0xFF25CFA2),
                            Color(0xFF136952),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : null,
                  color: selectedIndex == index ? null : Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
