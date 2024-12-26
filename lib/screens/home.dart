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
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:chatting_app/widgets/drawer.dart';
// import 'package:flutter/material.dart';
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
//   String? _currentUserPhone;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchCurrentUserPhone();
//   }
//
//   Future<void> _fetchCurrentUserPhone() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _currentUserPhone = prefs.getString('userPhoneNumber');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
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
//       body: _currentUserPhone == null ? const Center(child: CircularProgressIndicator()) : _buildChats(),
//     );
//   }
//
//   Widget _buildChats() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('chats')
//           .where('participants', arrayContains: _currentUserPhone)
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
//             final otherParticipantPhone = (chat['participants'] as List)
//                 .firstWhere((phone) => phone != _currentUserPhone, orElse: () => 'Unknown');
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
//                       receiverUserId: '', // Replace with actual receiver user ID if available
//                       receiverUserEmail: 'Unknown', // Replace with actual receiver email if available
//                       receiverUserPhone: otherParticipantPhone, // Replace with actual receiver phone if available
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