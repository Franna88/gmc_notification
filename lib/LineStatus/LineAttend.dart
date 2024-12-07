import 'package:flutter/material.dart';
import 'package:gmc/LineStatus/Popup/AttendingPopup.dart';
import 'package:gmc/LineStatus/Popup/CausePopup.dart';
import 'package:gmc/LineStatus/Popup/ResolvedPopup.dart';
import 'package:gmc/LineStatus/Reuseable/AttendingButton.dart';
import 'package:gmc/LineStatus/Reuseable/NotifyManagement.dart';
import 'package:gmc/LineStatus/Reuseable/UniversalTimer.dart';
import 'package:gmc/LineStatus/Reuseable/LineButton.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:gmc/myutility.dart';

class LineAttend extends StatefulWidget {
  final String lineLabel;
  final String documentId;
  final TimerService
      timerService; // Use the TimerService instance from UniversalTimer

  const LineAttend({
    required this.lineLabel,
    required this.documentId,
    required this.timerService,
    super.key,
  });

  @override
  State<LineAttend> createState() => _LineAttendState();
}

class _LineAttendState extends State<LineAttend> {
  late TimerService timerService;
  bool isAttending = false;

  @override
  void initState() {
    super.initState();
    timerService =
        widget.timerService; // Initialize with the passed TimerService instance
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: timerService.elapsedTimeNotifier,
      builder: (context, elapsedSeconds, child) {
        return Container(
          width: MyUtility(context).width,
          height: MyUtility(context).height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              Image.asset("images/GMC_Logo_White_Background_Black_Text 1.png"),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: LineButton(
                  lineLabel: widget.lineLabel,
                  isAttending: isAttending,
                  isOnline: false,
                  elapsedTime:
                      elapsedSeconds, // Pass elapsed time to LineButton
                  onTap: (_) {},
                ),
              ),
              const SizedBox(height: 20),
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
                        offset: const Offset(0, -4),
                        blurRadius: 4.0,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(4, 0),
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AttendingButton(
                        buttonText: 'ATTEND',
                        buttonColor:
                            isAttending ? GMCColors.green : Colors.black,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AttendingPopup(
                                  documentId: widget.documentId);
                            },
                          ).then((value) {
                            setState(() {
                              isAttending = true;
                            });
                          });
                        },
                      ),
                      AttendingButton(
                        buttonText: 'CAUSE',
                        buttonColor: Colors.black,
                        onPressed: () {
                          showDialog(
                            useSafeArea: false,
                            context: context,
                            builder: (BuildContext context) {
                              return CausePopup(documentId: widget.documentId);
                            },
                          );
                        },
                      ),
                      AttendingButton(
                        buttonText: 'RESOLVED',
                        buttonColor: Colors.black,
                        onPressed: () {
                          showDialog(
                            useSafeArea: false,
                            context: context,
                            builder: (BuildContext context) {
                              return ResolvedPopup(
                                  documentId: widget.documentId);
                            },
                          );
                        },
                      ),
                      NotifyManagement(isNotified: true),
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
