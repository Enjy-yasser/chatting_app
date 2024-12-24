import 'package:flutter/material.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .inversePrimary,
      // leading: IconButton(
      //     onPressed: () {
      //       Navigator.pushReplacementNamed(context, Routes.homeRoute);
      //     },
      //     icon: const Icon(Icons.arrow_back, size: 10, color: Colors.black,)),
      // // const Icon(Icons.arrow_back,size: 10,),
      title: Text(title, style: const TextStyle(color: Colors.black),
        textAlign: TextAlign.center,
      ),centerTitle: true,
    );
  }
  @override
    Size get preferredSize => const Size.fromHeight(kToolbarHeight);
//The preferredSize property defines the height of the app bar.
// kToolbarHeight is the standard height of a toolbar in Flutter.
  }
