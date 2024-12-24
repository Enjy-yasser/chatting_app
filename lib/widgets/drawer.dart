import 'package:chatting_app/constants/app_strings.dart';
import 'package:chatting_app/firebase_auth.dart';
import 'package:chatting_app/widgets/list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/app_routes.dart';

class MyDrawer extends StatelessWidget {
  // final void Function()? onProfileTap;
  // final void Function()? onSignOut;
  final FirebaseAuth  _auth= FirebaseAuth.instance;

   MyDrawer({super.key});
  // const MyDrawer({super.key, required this.onProfileTap, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Drawer(
       backgroundColor: Colors.grey[700],
      child: Column(
        mainAxisAlignment:MainAxisAlignment.spaceBetween ,
        children: [
          Column(
            children: [
              const DrawerHeader(child: Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              )),
              // home list tile
              MyListTile(
                text: AppStrings.home,
                icon: Icons.home,
                onTap: () =>Navigator.pushReplacementNamed(context,Routes.homeRoute),
              ),
              // profile list tile
              MyListTile(
                text: AppStrings.profile,
                icon: Icons.person,
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.profileRoute);
                },
              ),
            ],
          ),
          //sign out
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: MyListTile(
              text: AppStrings.signOut,
              icon: Icons.logout,
              onTap: () async{
    _auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, Routes.signUpRoute, (route) => false);

    }

    ),
    ),
    ],

      ),
    );
  }
}
