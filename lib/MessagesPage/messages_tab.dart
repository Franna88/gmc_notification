import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmc/MessagesPage/reusable_message_notification.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:gmc/myutility.dart';
import 'package:gmc/MessagesPage/person_chat.dart';
import 'package:intl/intl.dart';

class MessagesTab extends StatelessWidget {
  const MessagesTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String currentUserId =
        FirebaseAuth.instance.currentUser?.uid ?? 'unknown';

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Container(
        height: MyUtility(context).height * 0.67,
        width: MyUtility(context).width,
        decoration: BoxDecoration(
          color: GMCColors.lightGrey,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12.0),
            bottomRight: Radius.circular(12.0),
          ),
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
          stream: FirebaseFirestore.instance
              .collection('resolutionChats')
              .where('participants', arrayContains: currentUserId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final chats = snapshot.data!.docs;

            if (chats.isEmpty) {
              return const Center(child: Text("No active chats available"));
            }

            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                var chat = chats[index];
                String chatId = chat.id;

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('resolutionChats')
                      .doc(chatId)
                      .collection('messages')
                      .orderBy('timestamp', descending: true)
                      .limit(1)
                      .snapshots(),
                  builder: (context, messageSnapshot) {
                    if (!messageSnapshot.hasData ||
                        messageSnapshot.data!.docs.isEmpty) {
                      // If there are no messages, do not display anything
                      return const SizedBox.shrink();
                    }

                    final lastMessageDoc = messageSnapshot.data!.docs.first;

                    String lastMessageText = lastMessageDoc['text'];
                    String senderId = lastMessageDoc['senderId'];
                    DateTime timestamp = lastMessageDoc['timestamp'].toDate();
                    String formattedTimestamp =
                        DateFormat('d MMMM y HH:mm').format(timestamp);

                    // Fetch the sender's name from the 'users' collection
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(senderId)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox.shrink();
                        }

                        String lastMessageSender = 'Unknown';
                        if (userSnapshot.hasData && userSnapshot.data != null) {
                          final userData = userSnapshot.data!.data()
                              as Map<String, dynamic>?;
                          if (userData != null &&
                              userData.containsKey('name')) {
                            lastMessageSender = userData['name'];
                          }
                        }

                        return ReusableMessageNotification(
                          title: lastMessageSender,
                          dateTime: formattedTimestamp,
                          description: lastMessageText.length > 20
                              ? '${lastMessageText.substring(0, 20)}...'
                              : lastMessageText,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  chatName: lastMessageSender,
                                  chatId: chatId,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
