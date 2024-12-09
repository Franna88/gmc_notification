import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmc/MessagesPage/reusable_contact_containers.dart';
import 'package:gmc/Themes/gmc_colors.dart';
import 'package:gmc/myutility.dart';

class ContactTab extends StatelessWidget {
  const ContactTab({super.key});

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
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final users = snapshot.data!.docs;

            if (users.isEmpty) {
              return const Center(child: Text("No contacts available"));
            }

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];
                String userId = user.id;

                // Skip the current user
                if (userId == currentUserId) {
                  return const SizedBox.shrink();
                }

                // Check if the expected fields are present in the document
                final Map<String, dynamic>? userData =
                    user.data() as Map<String, dynamic>?;

                if (userData == null || !userData.containsKey('name')) {
                  return const SizedBox.shrink();
                }

                // Safely access the user fields
                final String userName = userData['name'] ?? 'Unknown User';

                // Use the original fields required for `ReusableContactContainers`
                return ReusableContactContainers(
                  title: userName,
                  dateTime:
                      '03/05/2015', // Placeholder value, can be updated later
                  description:
                      'This is a description text for a message.', // Placeholder value
                  contactUserId:
                      userId, // Pass the userId to ReusableContactContainers
                );
              },
            );
          },
        ),
      ),
    );
  }
}
