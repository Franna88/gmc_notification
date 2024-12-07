import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gmc/LineStatus/Reuseable/GroupButton.dart';
import 'package:gmc/LineStatus/Reuseable/LineButton.dart';
import 'package:gmc/LineStatus/Reuseable/UniversalTimer.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:gmc/myutility.dart';

class LineStatus extends StatefulWidget {
  final Function(String, int, String) onLineSelected;

  const LineStatus({
    super.key,
    required this.onLineSelected,
  });

  @override
  State<LineStatus> createState() => _LineStatusState();
}

class _LineStatusState extends State<LineStatus> {
  final CollectionReference systemsRef =
      FirebaseFirestore.instance.collection('systems');
  final CollectionReference downedLinesRef =
      FirebaseFirestore.instance.collection('downedLines');

  final UniversalTimer universalTimer = UniversalTimer();

  @override
  void initState() {
    super.initState();
    _addRealTimeListener();
  }

  // Add a real-time listener to the systems collection to listen for `online` changes
  void _addRealTimeListener() {
    systemsRef.snapshots().listen((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String documentId = doc.id;
        bool online = data['online'] ?? true;

        // Get TimerService from UniversalTimer
        TimerService timerService = universalTimer.getTimerForLine(documentId);

        if (online) {
          // Line is online: stop the timer and save elapsed time only if it is running
          if (timerService.isRunning) {
            int elapsedSeconds = timerService.secondsElapsed;

            // Stop the timer before performing any updates
            timerService.stop();
            print(
                'Line "$documentId" timer stopped at $elapsedSeconds seconds.');

            // Save the elapsed time to the corresponding downedLines document
            downedLinesRef
                .where('lineId', isEqualTo: documentId)
                .where('status', isEqualTo: 'unresolved')
                .orderBy('timestamp', descending: true)
                .limit(1)
                .get()
                .then((querySnapshot) {
              if (querySnapshot.docs.isNotEmpty) {
                var downedLineDoc = querySnapshot.docs.first;
                downedLineDoc.reference.update({
                  'elapsedTime': elapsedSeconds,
                  'status': 'resolved',
                }).then((_) {
                  print(
                      'Line "$documentId" downtime recorded with elapsed time: $elapsedSeconds seconds.');
                }).catchError((error) {
                  print(
                      'Error updating downedLines for line "$documentId": $error');
                });
              }
            }).catchError((error) {
              print(
                  'Error fetching downedLines for line "$documentId": $error');
            });

            // Reset the timer after recording the elapsed time
            timerService.reset();
            print('Line "$documentId" timer reset after coming online.');
          } else {
            print('Line "$documentId" is online, but timer is not running.');
          }

          // Reset Firestore fields if needed
          if (data['isAlreadyDown'] == true || data['attending'] == true) {
            doc.reference.update({
              'isAlreadyDown': false,
              'attending': false,
              'isUpdating': false,
            }).then((_) {
              print(
                  'Line "$documentId" updated: isAlreadyDown and attending set to false.');
            }).catchError((error) {
              print('Error updating line "$documentId" status: $error');
            });
          }
        } else {
          // Line is offline: start the timer only if it is not already running
          if (!timerService.isRunning) {
            timerService.start();
            print('Line "$documentId" timer started.');
          } else {
            print(
                'Line "$documentId" is offline, and timer is already running.');
          }

          // Prevent multiple document creations if there's an update in progress
          if (data['isUpdating'] == true) {
            print('Line "$documentId" is already being updated.');
            return;
          }

          // Use Firestore transaction to atomically update system and create new downedLines document
          FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot systemSnapshot =
                await transaction.get(doc.reference);

            if (systemSnapshot.exists) {
              bool isAlreadyDown = systemSnapshot.get('isAlreadyDown') ?? false;
              bool isUpdating = systemSnapshot.get('isUpdating') ?? false;

              // Proceed only if the line is not already marked as down and no transaction is in progress
              if (!isAlreadyDown && !isUpdating) {
                // Set a flag indicating that a transaction is in progress
                transaction.update(doc.reference, {'isUpdating': true});

                // Create a new downedLines document
                transaction.set(downedLinesRef.doc(), {
                  'lineId': documentId,
                  'lineName': data['line_Name'],
                  'timestamp': FieldValue.serverTimestamp(),
                  'status': 'unresolved',
                  'notificationTimestamps': [],
                  'technicianId': '',
                  'managerId': '',
                  'totalDownTime': '',
                  'messages': [],
                });

                // Update isAlreadyDown to true and clear the isUpdating flag after successful transaction
                transaction.update(doc.reference, {
                  'isAlreadyDown': true,
                  'isUpdating': false,
                });

                print(
                    'Transaction completed: downedLines document created for line "$documentId".');
              }
            }
          }).catchError((error) {
            print('Transaction failed for line "$documentId": $error');
            // Reset the isUpdating flag on failure
            doc.reference.update({'isUpdating': false});
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GroupButton(
                  buttonText: 'Group',
                  onTap: () {},
                ),
                const SizedBox(height: 20),
                Container(
                  height: MyUtility(context).height * 0.67,
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
                  child: StreamBuilder<QuerySnapshot>(
                    stream: systemsRef.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No lines available'));
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var lineData = snapshot.data!.docs[index];
                          String lineName = lineData['line_Name'];
                          bool online = lineData['online'];
                          bool isAttending = lineData['attending'];
                          String documentId = lineData.id;

                          // TimerService instance for each line from UniversalTimer
                          TimerService timerService =
                              universalTimer.getTimerForLine(documentId);

                          print(
                              'Line "$lineName" status is ${online ? 'online' : 'offline'}');

                          return ValueListenableBuilder<int>(
                            valueListenable: timerService.elapsedTimeNotifier,
                            builder: (context, elapsedTime, child) {
                              return LineButton(
                                lineLabel: lineName,
                                isOnline: online,
                                isAttending: isAttending,
                                elapsedTime: timerService.secondsElapsed,
                                onTap: (int elapsedSeconds) {
                                  widget.onLineSelected(
                                      lineName, elapsedSeconds, documentId);
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
