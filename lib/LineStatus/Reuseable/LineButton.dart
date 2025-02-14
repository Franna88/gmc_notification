import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gmc/LineStatus/Reuseable/UniversalTimer.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:gmc/myutility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class LineButton extends StatefulWidget {
  final String lineLabel;
  final bool isAttending;
  final String lineID;
  bool isOnline;
  final int elapsedTime; // Added elapsedTime parameter
  final Function(int) onTap;
  Function? onLongTap;
  bool offlineUi;
  bool navigatePage;
  final String lineProduction;

  LineButton({
    required this.lineLabel,
    required this.isAttending,
    required this.isOnline,
    required this.elapsedTime, // Initialized elapsedTime parameter
    required this.onTap,
    required this.lineID,
    required this.lineProduction,
    this.onLongTap,
    this.offlineUi = true,
    this.navigatePage = true,
    Key? key,
  }) : super(key: key);

  @override
  State<LineButton> createState() => _LineButtonState();
}

class _LineButtonState extends State<LineButton> {
  late final NewTimeService timerService;
  List<Map<String, String>> documentUrls = [];

  final CollectionReference systemsRef =
      FirebaseFirestore.instance.collection('systems');

  Future<void> _fetchDocuments() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('systems')
          .doc(widget.lineID)
          .get();
      print(widget.lineID);
      if (doc.exists) {
        final data = doc.data();
        if (data?['documents'] != null) {
          // Map the list of documents to their download URLs and file names
          setState(() {
            // Map the list of documents to their expected structure
            documentUrls = (data?['documents'] as List<dynamic>).map((e) {
              final map = e as Map<String, dynamic>;
              return {
                'downloadUrl': map['downloadUrl'] as String,
                'fileName': map['fileName'] as String,
              };
            }).toList();
          });
        }
      }

      print(documentUrls);
    } catch (e) {
      print('Error fetching documents: $e');
    }
  }

  Future<void> _downloadAndOpenFile(String url, String fileName) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Get the directory to save the file
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$fileName');

        // Save the file
        await file.writeAsBytes(response.bodyBytes);

        // Open the file
        await OpenFilex.open(file.path);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File downloaded and opened: $fileName')),
        );
      } else {
        throw Exception('Failed to download file');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading file: $e')),
      );
      print('Error downloading file: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDocuments();
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
          //  onTap: widget.navigatePage
          //     ? null
          //     : () {
          //         setState(() {
          //           widget.isOnline = !widget.isOnline;
          onTap: () {
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
          onLongPress: () async {
            final newStatus = !widget.isOnline; // Toggle the status
            try {
              // Update Firestore
              await systemsRef.doc(widget.lineID).update({'online': newStatus});
              print(
                  'Line "${widget.lineID}" status updated to ${newStatus ? "online" : "offline"} in Firestore.');

              // Update local state
              setState(() {
                widget.isOnline = newStatus;

                // Sync timer state with new status
                if (newStatus) {
                  timerService.reset(); // Stop and reset timer if online
                } else {
                  timerService.start(); // Start timer if offline
                }
              });
            } catch (error) {
              print('Error updating line "${widget.lineID}" status: $error');
            }
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
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
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
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 1.0),
                        child: Text(
                          widget.isOnline
                              ? 'Online' // Display "Online" when the line is online
                              : timerService.secondsElapsed < 10
                                  ? 'Attention' // Display "Attention" when offline and yellow
                                  : 'Offline', // Display "Offline" when offline and red
                          style: GoogleFonts.roboto(
                            color: widget.isOnline
                                ? GMCColors.green
                                : GMCColors.red,
                            fontSize: 14,
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
                    color: widget.isOnline
                        ? GMCColors.green // Green when online
                        : timerService.secondsElapsed < 10
                            ? Colors
                                .orange // Yellow for the first 10 seconds offline
                            : GMCColors.red, // Red after 10 seconds offline
                    border: Border.all(color: Colors.black),
                  ),
                  child: Stack(
                    children: [
                      // Left-aligned lineLabel
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            widget.lineLabel,
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      // Center-aligned timer when offline
                      if (!widget.isOnline)
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            formatTime(widget.elapsedTime),
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      // Right-aligned lineProduction
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: documentUrls.isNotEmpty ? 48.0 : 16.0,
                          ),
                          child: Text(
                            widget.lineProduction,
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      // Download button positioned to the right
                      if (documentUrls.isNotEmpty)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: PopupMenuButton<Map<String, String>>(
                              icon: const Icon(Icons.download,
                                  color: Colors.white),
                              onSelected: (document) {
                                _downloadAndOpenFile(document['downloadUrl']!,
                                    document['fileName']!);
                              },
                              itemBuilder: (context) => documentUrls
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) =>
                                        PopupMenuItem<Map<String, String>>(
                                      value: entry.value,
                                      child: Text(entry.value['fileName']!),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                    ],
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
