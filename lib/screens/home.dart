import 'package:chatting_app/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat.dart';
import 'contact.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.contacts),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactsPage()),
              );
            },
          )
        ],
      ),
      drawer: MyDrawer(),
      body: _buildChats(),
    );
  }

  Widget _buildChats() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .where('participants', arrayContains: _currentUserId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No active chats"));
        }

        final chats = snapshot.data!.docs;

        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index].data() as Map<String, dynamic>;
            final otherParticipantId = (chat['participants'] as List).firstWhere((id) => id != _currentUserId);
            final lastMessage = chat['lastMessage'];
            final contactName = chat['contactName'] ?? 'Unknown';

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.cyan,
                child: const Icon(Icons.person, color: Colors.white),
              ),
              title: Text(contactName), // Display the contact's name
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
    );
  }
}
// import 'package:chatting_app/widgets/drawer.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'chat.dart';
// import 'contact.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   String? _currentUserId;
//
//   @override
//   void initState() {
//     super.initState();
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       _currentUserId = user.uid;
//     } else {
//       // Handle the case when the user is not signed in
//       _currentUserId = null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_currentUserId == null) {
//       return Scaffold(
//         body: Center(
//           child: Text("User not signed in. Please sign in to continue."),
//         ),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Home"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.contacts),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => ContactsPage()),
//               );
//             },
//           )
//         ],
//       ),
//       drawer: MyDrawer(),
//       body: _buildChats(),
//     );
//   }
//
//   Widget _buildChats() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('chats')
//           .where('participants', arrayContains: _currentUserId)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Center(child: Text("No active chats"));
//         }
//
//         final chats = snapshot.data!.docs;
//
//         return ListView.builder(
//           itemCount: chats.length,
//           itemBuilder: (context, index) {
//             final chat = chats[index].data() as Map<String, dynamic>;
//             final otherParticipantId = (chat['participants'] as List).firstWhere((id) => id != _currentUserId);
//             final lastMessage = chat['lastMessage'];
//             final contactName = chat['contactName'] ?? 'Unknown';
//
//             return ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: Colors.cyan,
//                 child: const Icon(Icons.person, color: Colors.white),
//               ),
//               title: Text(contactName), // Display the contact's name
//               subtitle: Text(lastMessage ?? ''),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ChatScreen(
//                       receiverUserId: otherParticipantId,
//                       receiverUserEmail: 'Unknown', // Replace with actual receiver email if available
//                       receiverUserPhone: 'Unknown', // Replace with actual receiver phone if available
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }