import 'package:flutter/material.dart';
import 'package:gmc/LineStatus/LineAttend.dart';
import 'package:gmc/LineStatus/Reuseable/GroupButton.dart';
import 'package:gmc/LineStatus/Reuseable/LineButton.dart';
import 'package:gmc/LineStatus/Reuseable/TimeService.dart';
import 'package:gmc/MobileNavBar/MobileNavBar.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:gmc/myutility.dart';
import 'dart:async';

// LineStatus page using TimerService for consistent timer display
class LineStatus extends StatefulWidget {
  final Function(String, int) onLineSelected;
  final int initialSeconds;

  const LineStatus({
    super.key,
    required this.onLineSelected,
    this.initialSeconds = 0,
  });

  @override
  State<LineStatus> createState() => _LineStatusState();
}

class _LineStatusState extends State<LineStatus> {
  TimerService timerService = TimerService();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: timerService,
      builder: (context, _) {
        return Container(
          width: MyUtility(context).width,
          height: MyUtility(context).height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 25),
              Image.asset("images/GMC_Logo_White_Background_Black_Text 1.png"),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GroupButton(
                      buttonText: 'Group',
                      onTap: () {},
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: MyUtility(context).height * 0.7,
                      decoration: BoxDecoration(
                        color: GMCColors.lightGrey,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: Offset(0, -4),
                            blurRadius: 4.0,
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: Offset(4, 0),
                            blurRadius: 4.0,
                          ),
                        ],
                      ),
                      child: ListView(
                        padding: const EdgeInsets.all(8.0),
                        children: [
                          LineButton(
                            lineLabel: 'Line 1',
                            isAttending: false,
                            isOnline: true,
                            onTap: (int elapsedSeconds) {
                              widget.onLineSelected(
                                  'Line 1', timerService.secondsElapsed);
                            },
                          ),
                          LineButton(
                            lineLabel: 'Line 2',
                            isAttending: false,
                            isOnline: true,
                            onTap: (int elapsedSeconds) {
                              widget.onLineSelected(
                                  'Line 2', timerService.secondsElapsed);
                            },
                          ),
                          LineButton(
                            lineLabel: 'Line 3',
                            isAttending: false,
                            isOnline: true,
                            onTap: (int elapsedSeconds) {
                              widget.onLineSelected(
                                  'Line 3', timerService.secondsElapsed);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
