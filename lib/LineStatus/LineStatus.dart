import 'package:flutter/material.dart';
import 'package:gmc/LineStatus/GroupButton.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:gmc/myutility.dart';

class LineStatus extends StatefulWidget {
  const LineStatus({super.key});

  @override
  State<LineStatus> createState() => _LineStatusState();
}

class _LineStatusState extends State<LineStatus> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MyUtility(context).width,
      height: MyUtility(context).height,
      child: Column(
        children: [
          Image.asset("images/GMC_Logo_White_Background_Black_Text 1.png"),
          SizedBox(
            height: 10,
          ),
          GroupButton(
            buttonText: 'Group',
            onTap: () {},
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: GMCColors.lightGrey,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  offset: Offset(4, 0),
                  blurRadius: 6.0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  offset: Offset(0, -4),
                  blurRadius: 6.0,
                ),
              ],
              border: Border.all(
                color: Colors.black,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                'Styled Container',
                style: TextStyle(
                  color: GMCColors.green,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
