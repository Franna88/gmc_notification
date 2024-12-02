import 'package:flutter/material.dart';
import 'package:gmc/LineStatus/GroupButton.dart';
import 'package:gmc/LineStatus/LineButton.dart';
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25,
          ),
          Image.asset("images/GMC_Logo_White_Background_Black_Text 1.png"),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GroupButton(
                  buttonText: 'Group',
                  onTap: () {},
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: MyUtility(context).height * 0.7,
                  decoration: BoxDecoration(
                    color: GMCColors.lightGrey,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(0, -4), // Shadow on the top
                        blurRadius: 4.0,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(4, 0), // Shadow on the right
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  child: Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(8.0),
                      children: [
                        LineButton(
                          lineLabel: 'Line 1',
                          isAttending: false,
                          isOnline: true,
                          onTap: () {},
                        ),
                        LineButton(
                          lineLabel: 'Line 2',
                          isAttending: false,
                          isOnline: true,
                          onTap: () {},
                        ),
                        LineButton(
                          lineLabel: 'Line 3',
                          isAttending: false,
                          isOnline: true,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
