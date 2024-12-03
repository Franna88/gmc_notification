import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gmc/LineStatus/Reuseable/TimeService.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:gmc/myutility.dart';

class LineButton extends StatefulWidget {
  final String lineLabel;
  final bool isAttending;
  bool isOnline; // Set as mutable so that the internal state can modify it
  final Function(int) onTap; // Change this to pass timer value

  LineButton({
    required this.lineLabel,
    required this.isAttending,
    required this.isOnline,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<LineButton> createState() => _LineButtonState();
}

class _LineButtonState extends State<LineButton> {
  final TimerService timerService = TimerService();

  @override
  void initState() {
    super.initState();
    timerService.startTimer(); // Ensure timer is running globally
  }

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
        return GestureDetector(
          onTap: () {
            setState(() {
              widget.isOnline = !widget.isOnline;
            });
            widget.onTap(timerService.secondsElapsed);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: widget.isAttending,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(11),
                            topRight: Radius.circular(11),
                          ),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          'images/Person.svg',
                          color:
                              widget.isOnline ? GMCColors.green : GMCColors.red,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
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
                          color:
                              widget.isOnline ? GMCColors.green : GMCColors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                // Green or Red Container
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
                            style: TextStyle(
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
              ],
            ),
          ),
        );
      },
    );
  }
}
