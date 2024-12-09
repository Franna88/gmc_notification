import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gmc/LineStatus/Reuseable/UniversalTimer.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:gmc/myutility.dart';

class LineButton extends StatefulWidget {
  final String lineLabel;
  final bool isAttending;
  bool isOnline;
  final int elapsedTime; // Added elapsedTime parameter
  final Function(int) onTap;
  bool offlineUi;
  bool navigatePage;

  LineButton({
    required this.lineLabel,
    required this.isAttending,
    required this.isOnline,
    required this.elapsedTime, // Initialized elapsedTime parameter
    required this.onTap,
    this.offlineUi = true,
    this.navigatePage = true,
    Key? key,
  }) : super(key: key);

  @override
  State<LineButton> createState() => _LineButtonState();
}

class _LineButtonState extends State<LineButton> {
  late final NewTimeService timerService;

  @override
  void initState() {
    super.initState();
    timerService = UniversalTimer().getTimerForLine(widget.lineLabel);

    // Ensure timer syncs with the current `isOnline` state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isOnline) {
        timerService.reset();
      } else {
        timerService.start(); // Keep the timer running when offline
      }
    });
  }

  @override
  void didUpdateWidget(LineButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update timer state if `isOnline` changes
    if (oldWidget.isOnline != widget.isOnline) {
      if (widget.isOnline) {
        timerService.reset(); // Stop and reset timer when online
      } else {
        timerService.start(); // Start timer when offline
      }
    }
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: UniversalTimer(),
      builder: (context, _) {
        return GestureDetector(
          onTap: widget.navigatePage
              ? null
              : () {
                  setState(() {
                    widget.isOnline = !widget.isOnline;

                    if (widget.isOnline) {
                      timerService.reset();
                    } else {
                      timerService.start();
                    }
                  });

                  // Pass the current elapsed time to the parent callback
                  widget.onTap(timerService.secondsElapsed);
                },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Visibility(
                  visible: widget.offlineUi,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Visibility(
                        visible: widget.isAttending,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(11),
                              topRight: Radius.circular(11),
                            ),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            'images/person.svg',
                            color: widget.isOnline
                                ? GMCColors.green
                                : GMCColors.red,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(11),
                            topRight: Radius.circular(11),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 8.0),
                        child: Text(
                          widget.isOnline ? 'Online' : 'Offline',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: widget.isOnline
                                ? GMCColors.green
                                : GMCColors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MyUtility(context).width,
                  height: 55,
                  decoration: BoxDecoration(
                    color: widget.isOnline ? GMCColors.green : GMCColors.red,
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(
                    child: widget.isOnline
                        ? Text(
                            widget.lineLabel,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.lineLabel,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  formatTime(widget.elapsedTime),
                                  style: const TextStyle(
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
              ],
            ),
          ),
        );
      },
    );
  }
}
