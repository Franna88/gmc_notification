import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:gmc/Themes/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmc/myutility.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String chatName;
  final String chatId;

  const ChatPage({super.key, required this.chatName, required this.chatId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUserId =
      FirebaseAuth.instance.currentUser?.uid ?? 'unknown';

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      _firestore
          .collection('resolutionChats')
          .doc(widget.chatId)
          .collection('messages')
          .add({
        'text': _messageController.text,
        'timestamp': DateTime.now(),
        'senderId': currentUserId,
      });
      _messageController.clear();
    }
  }

  //   if (_messageController.text.isNotEmpty) {
  //     setState(() {
  //       _messages.add({
  //         'text': _messageController.text,
  //         'timestamp': DateTime.now(), // Save the current timestamp
  //       });
  //       _messageController.clear();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GMCColors.white,
      appBar: AppBar(
        title: Text(
          widget.chatName,
          style: TextStyles(context)
              .headingLarge
              .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
        ),
        backgroundColor: GMCColors.darkGrey,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white, // Set the color of the back arrow here
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('resolutionChats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    String senderId = message['senderId'];
                    DateTime timestamp = message['timestamp'].toDate();
                    String formattedDate =
                        DateFormat('d MMMM y HH:mm').format(timestamp);

                    // Update Firestore path to fetch user data
                    return FutureBuilder<DocumentSnapshot>(
                      future:
                          _firestore.collection('users').doc(senderId).get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData ||
                            !userSnapshot.data!.exists) {
                          return const SizedBox(); // Loading placeholder for user data
                        }

                        var userData =
                            userSnapshot.data!.data() as Map<String, dynamic>;
                        String senderName = userData['name'] ?? 'Unknown User';
                        bool isCurrentUser = senderId == currentUserId;

                        return Align(
                          alignment: isCurrentUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: isCurrentUser
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: MyUtility(context).width * 0.8,
                                    minWidth: 120,
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: GMCColors.darkGrey,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: isCurrentUser
                                        ? GMCColors.lightGrey
                                        : Colors.grey.shade300,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        senderName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: GMCColors.darkGrey,
                                        ),
                                      ),
                                      Text(
                                        message['text'],
                                        style: const TextStyle(fontSize: 16.0),
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4.0),
                                  decoration: const BoxDecoration(
                                    color: GMCColors.darkGrey,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      bottomLeft: Radius.circular(4.0),
                                      bottomRight: Radius.circular(4.0),
                                    ),
                                  ),
                                  child: Text(
                                    formattedDate,
                                    style: const TextStyle(
                                      fontSize: 10.0,
                                      color: GMCColors.orange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Container(
            color: GMCColors
                .darkGrey, // Dark grey background color for the chat bar
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  SizedBox(
                    width: MyUtility(context).width * 0.8,
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none, // Removes the border
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12.0),
                        fillColor: GMCColors
                            .white, // Background color for the text field
                        filled: true, // Ensures the fillColor is applied
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(8.0), // Border radius
                          borderSide: BorderSide.none, // No border line
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(8.0), // Border radius
                          borderSide: BorderSide.none, // No border line
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: const BoxDecoration(
                      color:
                          GMCColors.orange, // Orange background for the button
                      shape: BoxShape.circle, // Makes the container circular
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white, // White color for the send icon
                      ),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
