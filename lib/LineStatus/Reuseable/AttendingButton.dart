import 'package:flutter/material.dart';
import 'package:gmc/myutility.dart';

class AttendingButton extends StatefulWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color buttonColor;
  const AttendingButton(
      {super.key,
      required this.buttonText,
      required this.onPressed,
      required this.buttonColor});

  @override
  State<AttendingButton> createState() => _AttendingButtonState();
}

class _AttendingButtonState extends State<AttendingButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: MyUtility(context).width,
          height: 75,
          decoration: BoxDecoration(
            color: widget.buttonColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              widget.buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
