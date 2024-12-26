import 'package:chatting_app/widgets/custom_app_bar.dart';
import 'package:chatting_app/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  String? phone;

  @override
  void initState() {
    super.initState();
    _fetchphone();
  }
  Future<void> _fetchphone() async {
    try {
      print("User ID: ${currentUser.uid}");
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      print("Setting phone number: $phone");

      if (userDoc.exists) {
        setState(() {
          phone = userDoc.get('phone') ?? "Phone number not available";
        });
        print("Phone number fetched successfully: $phone");
      } else {
        setState(() {
          phone = "Phone number not available";
        });
        print("User document does not exist");
      }
    } catch (e) {
      print("Error fetching phone number: $e");
      setState(() {
        phone = "Error fetching phone number";
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Profile Page"),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Center(
          child: ListView(
            children: [
              const SizedBox(height: 60),
              // profile picture
              const Icon(Icons.person, size: 60),
              // email
              Text(
                currentUser.email!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 10),
              Text(
                phone ?? "Loading phone number...",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}