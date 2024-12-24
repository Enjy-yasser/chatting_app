import 'package:chatting_app/widgets/custom_app_bar.dart';
import 'package:chatting_app/widgets/drawer.dart';
import 'package:flutter/material.dart';

import '../constants/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void goToProfilePage(){
    Navigator.pop(context); //pop out el drawer
    Navigator.pushReplacementNamed(
        context, Routes.profileRoute);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const CustomAppBar(title: "Home"),
      drawer:  MyDrawer(),
    // MyDrawer(
        // onProfileTap: goToProfilePage,
        // onSignOut: () {  },),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            InkWell(
              //Ink well 3lshan n click
              onTap: (){
                Navigator.pushReplacementNamed(context, Routes.chatRoute);
              },
              child: const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ListTile(
                      leading: CircleAvatar(radius: 30,),
                      title: Text("Chat 1",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.black,),
            InkWell(
              onTap: (){
                Navigator.pushReplacementNamed(context, Routes.chatRoute2);
              },
              child: const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ListTile(
                      leading: CircleAvatar(radius: 30,backgroundColor: Colors.cyan,),
                      title: Text("Chat 2",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
        ),
      );
  }
}
