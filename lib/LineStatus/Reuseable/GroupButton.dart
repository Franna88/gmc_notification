import 'package:flutter/material.dart';
import 'package:gmc/Themes/gmc_colors.dart';

class GroupButton extends StatelessWidget {
  String buttonText;
  VoidCallback onTap;
  GroupButton({Key? key, required this.buttonText, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: -4,
            right: -4,
            child: Container(
              decoration: BoxDecoration(
                color: GMCColors.orange,
                borderRadius: BorderRadius.circular(12.0),
              ),
              width: 145,
              height: 50,
            ),
          ),
          Container(
            width: 145,
            decoration: BoxDecoration(
              color: GMCColors.darkBrown,
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            child: Text(
              buttonText,
              style: TextStyle(
                color: GMCColors.orange,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
