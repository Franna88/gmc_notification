import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmc/MainComponants/blueButton.dart';
import 'package:gmc/MessagesPage/person_chat.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:gmc/Themes/text_styles.dart';
import 'package:gmc/myutility.dart'; // Ensure this path is correct

class ReusableContactContainers extends StatelessWidget {
  final String title;
  final String dateTime;
  final String description;
  final String contactUserId;

  const ReusableContactContainers({
    super.key,
    required this.title,
    required this.dateTime,
    required this.description,
    required this.contactUserId,
  });

  Future<void> _handleMessagePressed(
      BuildContext context, String contactUserId) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    if (currentUserId == 'unknown') {
      // Handle the case when user is not logged in
      return;
    }

    try {
      // Check if a chat already exists between the two users
      QuerySnapshot existingChat = await firestore
          .collection('resolutionChats')
          .where('participants', arrayContains: currentUserId)
          .get();

      DocumentSnapshot? existingChatDoc;
      for (var doc in existingChat.docs) {
        List participants = doc['participants'];
        if (participants.contains(contactUserId)) {
          existingChatDoc = doc;
          break;
        }
      }

      String chatId;

      if (existingChatDoc != null) {
        // If chat already exists, use that chatId
        chatId = existingChatDoc.id;
      } else {
        // If chat does not exist, create a new one
        DocumentReference newChat =
            await firestore.collection('resolutionChats').add({
          'participants': [currentUserId, contactUserId],
          'createdAt': FieldValue.serverTimestamp(),
        });
        chatId = newChat.id;
      }

      // Navigate to the ChatPage with the correct chatId
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            chatName: title,
            chatId: chatId,
          ),
        ),
      );
    } catch (e) {
      print('Error initiating chat: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: MyUtility(context).width * 0.8,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: GMCColors.darkGrey), // Dark grey border
          borderRadius: BorderRadius.circular(8), // Optional: rounded corners
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyles(context)
                      .bold
                      .copyWith(color: GMCColors.darkGrey),
                ),
                BlueButton(
                  text: 'Message',
                  onPressed: () async {
                    await _handleMessagePressed(context, contactUserId);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
