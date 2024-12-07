import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gmc/LineStatus/Reuseable/PopupButton.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AttendingPopup extends StatefulWidget {
  final String documentId;

  const AttendingPopup({required this.documentId, super.key});

  @override
  State<AttendingPopup> createState() => _AttendingPopupState();
}

class _AttendingPopupState extends State<AttendingPopup> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<String> fetchTechnicianName(String technicianId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(technicianId)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        return data['name'] ?? 'Unknown Technician';
      }
    } catch (e) {
      print('Error fetching technician name: $e');
    }
    return 'Unknown Technician';
  }

  Future<void> updateTechnicianInSystems(
      String technicianId, String technicianName) async {
    try {
      // Update the technician info in the systems collection
      await FirebaseFirestore.instance
          .collection('systems')
          .doc(widget.documentId)
          .update({
        'technicianName': technicianName,
      });
      print('Technician updated in systems collection.');
    } catch (e) {
      print('Failed to update technician info in systems: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: GMCColors.darkGrey,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(6.0),
              ),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SvgPicture.asset('images/popback.svg')),
                const Text(
                  'ATTEND',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: GMCColors.orange,
                  ),
                ),
                const SizedBox(width: 24.0),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(6.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16.0),
                // Message
                Text(
                  '${currentUser?.displayName ?? "User"} are you attending to this issue?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Roboto',
                  ),
                ),
                const SizedBox(height: 24.0),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PopupButton(
                      onTap: () async {
                        if (currentUser != null) {
                          // Get technician info
                          String technicianId = currentUser!.uid;
                          String technicianName = await fetchTechnicianName(
                              technicianId); // Fetch from Firestore

                          // Update the systems collection to store technician info
                          await updateTechnicianInSystems(
                              technicianId, technicianName);

                          // Update the systems collection to mark as attending
                          FirebaseFirestore.instance
                              .collection('systems')
                              .doc(widget.documentId)
                              .update({'attending': true}).then((_) {
                            // Also update the downedLines collection with the technician info
                            FirebaseFirestore.instance
                                .collection('downedLines')
                                .where('lineId', isEqualTo: widget.documentId)
                                .where('status', isEqualTo: 'unresolved')
                                .orderBy('timestamp', descending: true)
                                .limit(1)
                                .get()
                                .then((snapshot) {
                              if (snapshot.docs.isNotEmpty) {
                                snapshot.docs.first.reference.update({
                                  'technicianId': technicianId,
                                  'technicianName': technicianName,
                                  'status': 'attending',
                                }).then((_) {
                                  print(
                                      'Technician assigned to downed line successfully.');

                                  // Close the dialog and return to the previous screen
                                  Navigator.of(context).pop();
                                }).catchError((error) {
                                  print('Failed to update downedLines: $error');
                                });
                              } else {
                                print(
                                    'No matching downedLines document found.');
                              }
                            }).catchError((error) {
                              print(
                                  'Failed to get downedLines document: $error');
                            });
                          }).catchError((error) {
                            print(
                                'Failed to update systems collection: $error');
                          });
                        } else {
                          print('No logged-in user found.');
                        }
                      },
                      buttonColor: GMCColors.orange,
                      buttonText: "Accept",
                    ),
                    PopupButton(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      buttonColor: GMCColors.red,
                      buttonText: "Cancel",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
