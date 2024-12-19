import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:gmc/myutility.dart';

class NotifyManagement extends StatefulWidget {
  final bool isNotified;
  final String id;
  const NotifyManagement(
      {super.key, required this.isNotified, required this.id});

  @override
  State<NotifyManagement> createState() => _NotifyManagementState();
}

class _NotifyManagementState extends State<NotifyManagement> {
  String _message = '';

  @override
  void initState() {
    _getMessage();
    super.initState();
  }

  Future<void> _getMessage() async {
    try {
      // Get the message from Firestore
      final doc = await FirebaseFirestore.instance
          .collection('systems')
          .doc(widget.id)
          .get();
      String message = "Default Message";
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data.containsKey('message')) {
        message = doc.get('message');
      } else {
        print('Message key does not exist.');
      }

      setState(() {
        _message = message;
      });
    } catch (e) {
      print('Error getting message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isNotified, // Controls visibility based on `isNotified`
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: MyUtility(context).width,
          decoration: BoxDecoration(
            color: GMCColors.darkTeal,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alert',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: GMCColors.darkRed,
                  ),
                ),
                Text(
                  _message,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: GMCColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
