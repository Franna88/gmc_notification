import 'package:flutter/material.dart';

class PopupButton extends StatefulWidget {
  final Color buttonColor;
  final VoidCallback onTap;
  final String buttonText;

  const PopupButton({
    super.key,
    required this.onTap,
    required this.buttonColor,
    required this.buttonText,
  });

  @override
  State<PopupButton> createState() => _PopupButtonState();
}

class _PopupButtonState extends State<PopupButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: Offset(0, 4), // Shadow positioned slightly below the button
            blurRadius: 4.0,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: widget.onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 14.0),
        ),
        child: Text(
          widget.buttonText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
