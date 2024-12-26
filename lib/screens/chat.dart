import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chatting_app/models/message.dart';
import 'package:chatting_app/widgets/custom_app_bar2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/custom_text_field.dart';

class ChatScreen extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserId;
  final String receiverUserPhone;

  const ChatScreen({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserId,
    required this.receiverUserPhone,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  String getChatId() {
    return _currentUserId.hashCode <= widget.receiverUserId.hashCode
        ? '$_currentUserId-${widget.receiverUserId}'
        : '${widget.receiverUserId}-$_currentUserId';
  }

  void _sendLocation(String locationMessage) {
    _sendMessage(locationMessage);
  }

  Future<void> _openLink(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cannot open link")));
    }
  }

  Future<String> _getContactName(String phoneNumber) async {
    // Request permission to access contacts
    await Permission.contacts.request();

    // Fetch all contacts
    Iterable<Contact> contacts = await ContactsService.getContacts();

    // Find contact matching the phone number
    for (Contact contact in contacts) {
      for (Item phone in contact.phones!) {
        if (phone.value == phoneNumber) {
          return contact.displayName ?? 'Unknown';
        }
      }
    }
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar2(title: widget.receiverUserEmail),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(getChatId())
                  .collection('chats')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No messages yet"));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data() as Map<String, dynamic>;
                    final isSender = data['senderId'] == _currentUserId;
                    final message = data['message'];

                    if (message == null || message.isEmpty) {
                      return SizedBox.shrink();
                    }

                    final isLink = message.startsWith('https://');
                    return GestureDetector(
                      onTap: isLink ? () => _openLink(message) : null,
                      child: BubbleSpecialThree(
                        text: message ?? '',
                        color: isSender ? Colors.green : Colors.blue,
                        isSender: isSender,
                        tail: true,
                        textStyle: TextStyle(
                          color: isSender ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          CustomTextField(
            controller: _messageController,
            onSend: () {
              final message = _messageController.text.trim();
              if (message.isNotEmpty) {
                _sendMessage(message);
              }
            },
            onSendLocation: _sendLocation,
          ),
        ],
      ),
    );
  }

  void _sendMessage(String message) async {
    final chatId = getChatId();

    final messageData = Message(
      senderId: _currentUserId,
      senderEmail: FirebaseAuth.instance.currentUser!.email ?? '',
      senderPhone: FirebaseAuth.instance.currentUser!.phoneNumber ?? '',
      message: message,
      timestamp: Timestamp.now(),
    );

    // Save the message to Firestore
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(chatId)
        .collection('chats')
        .add(messageData.toMap());

    // Get the contact name
    final contactName = await _getContactName(widget.receiverUserPhone);

    // Save chat metadata to Firestore
    await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
      'participants': [_currentUserId, widget.receiverUserId],
      'lastMessage': message,
      'timestamp': Timestamp.now(),
      'contactName': contactName, // Store the contact's name
    }, SetOptions(merge: true));

    _messageController.clear();
  }
}
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
// import 'package:chatting_app/models/message.dart';
// import 'package:chatting_app/widgets/custom_app_bar2.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../widgets/custom_text_field.dart';
//
// class ChatScreen extends StatefulWidget {
//   final String receiverUserEmail;
//   final String receiverUserId;
//   final String receiverUserPhone;
//
//   const ChatScreen({
//     super.key,
//     required this.receiverUserEmail,
//     required this.receiverUserId,
//     required this.receiverUserPhone,
//   });
//
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;
//
//   String getChatId() {
//     return _currentUserId.hashCode <= widget.receiverUserId.hashCode
//         ? '$_currentUserId-${widget.receiverUserId}'
//         : '${widget.receiverUserId}-$_currentUserId';
//   }
//
//   void _sendLocation(String locationMessage) {
//     _sendMessage(locationMessage);
//   }
//
//   Future<void> _openLink(String url) async {
//     Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cannot open link")));
//     }
//   }
//
//   Future<String> _getContactName(String phoneNumber) async {
//     // Request permission to access contacts
//     await Permission.contacts.request();
//
//     // Fetch all contacts
//     Iterable<Contact> contacts = await ContactsService.getContacts();
//
//     // Find contact matching the phone number
//     for (Contact contact in contacts) {
//       for (Item phone in contact.phones!) {
//         if (phone.value == phoneNumber) {
//           return contact.displayName ?? 'Unknown';
//         }
//       }
//     }
//     return 'Unknown';
//   }
//
//   Future<String?> _getPhoneNumberLocally() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('userPhoneNumber');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar2(title: widget.receiverUserEmail),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('messages')
//                   .doc(getChatId())
//                   .collection('chats')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text("No messages yet"));
//                 }
//
//                 final messages = snapshot.data!.docs;
//
//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final data = messages[index].data() as Map<String, dynamic>;
//                     final isSender = data['senderId'] == _currentUserId;
//                     final message = data['message'];
//
//                     if (message == null || message.isEmpty) {
//                       return SizedBox.shrink();
//                     }
//
//                     final isLink = message.startsWith('https://');
//                     return GestureDetector(
//                       onTap: isLink ? () => _openLink(message) : null,
//                       child: BubbleSpecialThree(
//                         text: message ?? '',
//                         color: isSender ? Colors.green : Colors.blue,
//                         isSender: isSender,
//                         tail: true,
//                         textStyle: TextStyle(
//                           color: isSender ? Colors.white : Colors.black,
//                           fontSize: 16,
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           CustomTextField(
//             controller: _messageController,
//             onSend: () {
//               final message = _messageController.text.trim();
//               if (message.isNotEmpty) {
//                 _sendMessage(message);
//               }
//             },
//             onSendLocation: _sendLocation,
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _sendMessage(String message) async {
//     final chatId = getChatId();
//
//     final senderPhone = await _getPhoneNumberLocally();
//
//     final messageData = Message(
//       senderId: _currentUserId,
//       senderEmail: FirebaseAuth.instance.currentUser!.email ?? '',
//       senderPhone: senderPhone ?? '',
//       message: message,
//       timestamp: Timestamp.now(),
//     );
//
//     // Save the message to Firestore
//     await FirebaseFirestore.instance
//         .collection('messages')
//         .doc(chatId)
//         .collection('chats')
//         .add(messageData.toMap());
//
//     // Get the contact name
//     final contactName = await _getContactName(widget.receiverUserPhone);
//
//     // Save chat metadata to Firestore
//     await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
//       'participants': [_currentUserId, widget.receiverUserId],
//       'lastMessage': message,
//       'timestamp': Timestamp.now(),
//       'contactName': contactName, // Store the contact's name
//     }, SetOptions(merge: true));
//
//     _messageController.clear();
//   }
// }