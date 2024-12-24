import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String title;
  // final Function onPressed;
  final VoidCallback onPressed; // Use VoidCallback for type safety


  const MyButton({super.key, required this.title, required this.onPressed, required Widget child});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: Theme.of(context).colorScheme.inversePrimary,
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        onPressed: onPressed,
      minWidth: 200,
      height: 42,
      child: Text(title,style: const TextStyle(color: Colors.black),
      ),),
    );
  }
}
