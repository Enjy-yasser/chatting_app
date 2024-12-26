// import 'package:flutter/material.dart';
// import 'package:contacts_service/contacts_service.dart';
// import '../contact.dart';
// import 'chat.dart';
//
// class ContactsPage extends StatefulWidget {
//   const ContactsPage({super.key});
//
//   @override
//   State<ContactsPage> createState() => _ContactsPageState();
// }
//
// class _ContactsPageState extends State<ContactsPage> {
//   List<Contact> _contacts = [];
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchContacts();
//   }
//
//   void fetchContacts() async {
//     final contacts = await getContacts(context);
//     setState(() {
//       _contacts = contacts;
//       _isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _contacts.isEmpty
//           ? const Center(child: Text("No contacts available"))
//           : ListView.builder(
//         itemCount: _contacts.length,
//         itemBuilder: (context, index) {
//           final contact = _contacts[index];
//
//           return ListTile(
//             title: Text(contact.displayName ?? "No Name"),
//             subtitle: Text(contact.phones?.first.value ?? "No Phone"),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ChatScreen(
//                     receiverUserPhone: contact.phones?.first.value ?? '', receiverUserEmail: '', receiverUserId: '',
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import '../contact.dart';
import 'chat.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  void fetchContacts() async {
    final contacts = await getContacts(context);
    setState(() {
      _contacts = contacts;
      _isLoading = false;
    });
  }

  Future<String?> _getUserIdByPhone(String phoneNumber) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: phoneNumber)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id; // Return the user ID
    }
    return null; // No user found
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _contacts.isEmpty
          ? const Center(child: Text("No contacts available"))
          : ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];

          return ListTile(
            title: Text(contact.displayName ?? "No Name"),
            subtitle: Text(contact.phones?.first.value ?? "No Phone"),
            onTap: () async {
              final userId = await _getUserIdByPhone(contact.phones?.first.value ?? '');
              if (userId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                       receiverUserEmail: '',
                      receiverUserId:userId,
                      receiverUserPhone: contact.phones?.first.value ?? '',

                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("User  not found")),
                );
              }
            },
          );
        },
      ),
    );
  }
}