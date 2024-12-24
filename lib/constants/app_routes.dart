import 'package:chatting_app/screens/chat.dart';
import 'package:chatting_app/screens/chat2.dart';
import 'package:chatting_app/screens/home.dart';
import 'package:chatting_app/screens/login.dart';
import 'package:chatting_app/screens/profile.dart';
import 'package:chatting_app/screens/sign_up.dart';
import 'package:flutter/material.dart';

class Routes{
  static const String signUpRoute ='/';
  static const String loginRoute ='login';
  static const String profileRoute ='profile';
  static const String homeRoute ='home';
  static const String chatRoute ='chat';
  static const String chatRoute2 ='chat2';

  static Route? getRoute(RouteSettings settings){
    switch(settings.name){
      case signUpRoute:
        return MaterialPageRoute(builder: (context)=> const SignUpScreen());
      case loginRoute:
        return MaterialPageRoute(builder: (context)=> const LoginScreen());
      case profileRoute:
        return MaterialPageRoute(builder: (context)=> const ProfileScreen());
      case chatRoute:
        return MaterialPageRoute(builder: (context)=> const ChatScreen());
      case chatRoute2:
        return MaterialPageRoute(builder: (context)=> const chat_2());

      default:
        return MaterialPageRoute(builder: (context)=> const HomeScreen());

    }
  }

}