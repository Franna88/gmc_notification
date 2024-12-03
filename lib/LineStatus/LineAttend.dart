import 'package:flutter/material.dart';
import 'package:gmc/LineStatus/Popup/AttendingPopup.dart';
import 'package:gmc/LineStatus/Popup/CausePopup.dart'; // Import CausePopup
import 'package:gmc/LineStatus/Popup/ResolvedPopup.dart';
import 'package:gmc/LineStatus/Reuseable/AttendingButton.dart';
import 'package:gmc/LineStatus/Reuseable/NotifyManagement.dart';
import 'package:gmc/LineStatus/Reuseable/TimeService.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:gmc/myutility.dart';
import 'dart:async';

class LineAttend extends StatefulWidget {
  final String lineLabel;
  final int initialSeconds;

  const LineAttend({
    required this.lineLabel,
    required this.initialSeconds,
    super.key,
  });

  @override
  State<LineAttend> createState() => _LineAttendState();
}

class _LineAttendState extends State<LineAttend> {
  TimerService timerService = TimerService();

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

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
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MyUtility(context).width,
                  height: 55,
                  decoration: BoxDecoration(
                    color: GMCColors.red,
                    border: Border.all(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.lineLabel,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formatTime(timerService.secondsElapsed),
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Container(
                  height: MyUtility(context).height * 0.6,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AttendingButton(
                        buttonText: 'ATTEND',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AttendingPopup();
                            },
                          );
                        },
                      ),
                      AttendingButton(
                        buttonText: 'CAUSE',
                        onPressed: () {
                          showDialog(
                            useSafeArea: false,
                            context: context,
                            builder: (BuildContext context) {
                              return CausePopup();
                            },
                          );
                        },
                      ),
                      AttendingButton(
                        buttonText: 'RESOLVED',
                        onPressed: () {
                          showDialog(
                            useSafeArea: false,
                            context: context,
                            builder: (BuildContext context) {
                              return ResolvedPopup();
                            },
                          );
                        },
                      ),
                      NotifyManagement(
                        isNotified: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
