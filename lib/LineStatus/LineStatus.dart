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
                color: GMCColors.lightTeal,
                borderRadius: BorderRadius.circular(12)),
          )
        ],
      ),
    );
  }
}
