import 'package:flutter/material.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:gmc/Themes/text_styles.dart';
import 'package:gmc/myutility.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String chatName;

  ChatPage({Key? key, required this.chatName}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = []; // Store messages with timestamps

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _messageController.text,
          'timestamp': DateTime.now(), // Save the current timestamp
        });
        _messageController.clear();
      });
    }
  }

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
          icon: Icon(
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
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                // Get the message and its timestamp
                Map<String, dynamic> message = _messages[index];
                DateTime timestamp = message['timestamp'];
                String formattedDate =
                    DateFormat('d MMMM y HH:mm').format(timestamp);

                return Align(
                  alignment: Alignment
                      .centerRight, // Aligns the container to the right
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MyUtility(context).width *
                                0.8, // Adjust max width as needed
                            minWidth: 120,
                          ),
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: GMCColors.darkGrey,
                              width: 1.0,
                            ), // Dark grey border
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              bottomLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                            color: index % 2 == 0
                                ? Colors.grey.shade300
                                : GMCColors.lightGrey,
                          ),
                          child: Text(
                            message['text'],
                            style: TextStyle(fontSize: 16.0), // Text style
                            textAlign:
                                TextAlign.right, // Aligns text to the right
                            softWrap:
                                true, // Wraps text to the next line if too long
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: GMCColors.darkGrey,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              bottomLeft: Radius.circular(4.0),
                              bottomRight: Radius.circular(4.0),
                            ),
                          ),
                          child: Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 10.0,
                              color:
                                  GMCColors.orange, // Color for the date/time
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  Container(
                    width: MyUtility(context).width * 0.8,
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none, // Removes the border
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
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
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color:
                          GMCColors.orange, // Orange background for the button
                      shape: BoxShape.circle, // Makes the container circular
                    ),
                    child: IconButton(
                      icon: Icon(
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
