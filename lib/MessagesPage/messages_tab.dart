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

    return Container(
      height: MyUtility(context).height * 0.8,
      width: MyUtility(context).width * 0.9,
      decoration: const BoxDecoration(
        color: GMCColors.lightGrey,
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('resolutionChats')
            .where('participants', arrayContains: currentUserId)
            .snapshots(),
        builder: (context, resolutionSnapshot) {
          if (!resolutionSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final resolutionChats = resolutionSnapshot.data!.docs;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('downedLines')
                .where('status', isEqualTo: 'attending')
                .snapshots(),
            builder: (context, downedLinesSnapshot) {
              if (!downedLinesSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              // Filter downedLines to only include those with both supervisorId and technicianId
              final downedLines = downedLinesSnapshot.data!.docs.where((line) {
                final data = line.data() as Map<String, dynamic>;
                return (data['supervisorId'] ?? '').isNotEmpty &&
                    (data['technicianId'] ?? '').isNotEmpty;
              }).toList();

              // Combine resolutionChats and filtered downedLines into one list
              final combinedChats = [
                ...resolutionChats.map((chat) => {
                      'type': 'resolutionChat',
                      'data': chat,
                    }),
                ...downedLines.map((line) => {
                      'type': 'downedLine',
                      'data': line,
                    }),
              ];

              if (combinedChats.isEmpty) {
                return const Center(
                    child: Text("No active chats or downed lines available"));
              }

              return ListView.builder(
                itemCount: combinedChats.length,
                itemBuilder: (context, index) {
                  final chatItem = combinedChats[index];
                  if (chatItem['type'] == 'resolutionChat') {
                    var chat = chatItem['data'] as QueryDocumentSnapshot;
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
                          return const SizedBox.shrink();
                        }

                        final lastMessageDoc = messageSnapshot.data!.docs.first;
                        String lastMessageText = lastMessageDoc['text'];
                        String senderId = lastMessageDoc['senderId'];
                        DateTime timestamp =
                            lastMessageDoc['timestamp'].toDate();
                        String formattedTimestamp =
                            DateFormat('d MMMM y HH:mm').format(timestamp);

                        // Fetch the name of the other participant in the chat
                        final participants =
                            chat['participants'] as List<dynamic>;
                        final otherUserId = participants.firstWhere(
                          (id) => id != currentUserId,
                          orElse: () => null,
                        );

                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(otherUserId)
                              .get(),
                          builder: (context, userSnapshot) {
                            if (!userSnapshot.hasData ||
                                !userSnapshot.data!.exists) {
                              return const SizedBox.shrink();
                            }

                            final userData = userSnapshot.data!.data()
                                as Map<String, dynamic>;
                            String otherUserName =
                                userData['name'] ?? 'Unknown';

                            return ReusableMessageNotification(
                              title: otherUserName,
                              dateTime: formattedTimestamp,
                              description: lastMessageText.length > 20
                                  ? '${lastMessageText.substring(0, 20)}...'
                                  : lastMessageText,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      chatName: otherUserName,
                                      chatId: chatId,
                                      isDownedLine: false,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  } else if (chatItem['type'] == 'downedLine') {
                    var downedLine = chatItem['data'] as QueryDocumentSnapshot;
                    final lineData = downedLine.data() as Map<String, dynamic>;
                    String downedLineId = downedLine.id;
                    String lineName = lineData['lineName'];
                    DateTime timestamp =
                        (lineData['timestamp'] as Timestamp).toDate();
                    String formattedTimestamp =
                        DateFormat('d MMMM y HH:mm').format(timestamp);

                    return ReusableMessageNotification(
                      title: lineName,
                      dateTime: formattedTimestamp,
                      description: 'Line is currently attended',
                      titleStyle: const TextStyle(
                        color: Colors.red, // Make downedLines red
                        fontWeight: FontWeight.bold,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              chatName: lineName,
                              chatId: downedLineId,
                              isDownedLine: true,
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              );
            },
          );
        },
      ),
    );
  }
}
