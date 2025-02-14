import 'package:flutter/material.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class BlackTextField extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final double? width;

  const BlackTextField({
    super.key,
    required this.title,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.width,
  });

  @override
  State<BlackTextField> createState() => _BlackTextFieldState();
}

class _BlackTextFieldState extends State<BlackTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w400,
              color: const Color(0xFF323232),
              fontSize: 16),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: widget.width,
          height: 50,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                  spreadRadius: 1,
                ),
              ],
              border: Border.all(
                color: const Color(0xFFDDDDDD),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            child: TextField(
              controller: widget.controller,
              obscureText: _obscureText,
              keyboardType: widget.keyboardType,
              style: const TextStyle(color: Color(0xFF323232)),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                suffixIcon: widget.obscureText
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF242728),
                          ),
                          child: Icon(
                            _obscureText
                                ? Icons.lock_outline
                                : Icons.lock_open_outlined,
                            color: const Color(0xFF25CFA2),
                            size: 22,
                          ),
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF242728),
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: const Color(0xFF25CFA2),
                          size: 22,
                        ),
                      ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
