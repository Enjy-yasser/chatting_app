import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chat.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: _currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No chats available"));
          }

          final chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index].data() as Map<String, dynamic>;
              final otherParticipantId = (chat['participants'] as List).firstWhere((id) => id != _currentUserId);
              final lastMessage = chat['lastMessage'];

              return ListTile(
                title: Text('Chat with $otherParticipantId'), // You can replace this with a better display name
                subtitle: Text(lastMessage ?? ''),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        receiverUserId: otherParticipantId,
                        receiverUserEmail: 'Unknown', // Replace with actual receiver email if available
                        receiverUserPhone: 'Unknown', // Replace with actual receiver phone if available
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}