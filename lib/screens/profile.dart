import 'package:chatting_app/widgets/custom_app_bar.dart';
import 'package:chatting_app/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //get current user
  final currentUser=FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Profile Page"),drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Center(
          child: ListView(
            children: [
              const SizedBox(height: 60),
              // profile picture
              const Icon(Icons.person),
              // email
              Text(
                currentUser.email!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black),),
              // username
              const SizedBox(height: 10),
              // Text(
              //   currentUser.username!,
              //   textAlign: TextAlign.center,
              //   style: const TextStyle(color: Colors.black),),
            ],

          ),
        ),
      ) ,
    );
  }
}
