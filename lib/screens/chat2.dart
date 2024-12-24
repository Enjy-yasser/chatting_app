import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chatting_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

import '../constants/const.dart';
import '../models/model_chat.dart';
import '../widgets/custom_app_bar2.dart';

class chat_2 extends StatefulWidget {
  const chat_2({super.key});

  @override
  State<chat_2> createState() => _chat_2State();
}

class _chat_2State extends State<chat_2> {
  TextEditingController text=TextEditingController();
  String myname='chat2';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar2(title: "Chat 2"),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: Chat.length,
                itemBuilder: (_,index)=> BubbleSpecialThree(
                  text: Chat[index].text.toString(), // 3lshan mytl3sh instance of model
                  color: Chat[index].sender_name== myname ? Colors.green : Colors.blue,
                  isSender: Chat[index].sender_name== myname ? true : false,
                  tail: true, //heta gamb zay space
                  textStyle: TextStyle(
                      color: Chat[index].sender_name== myname ? Colors.white : Colors.black,
                      fontSize: 16),
                ),
              ),
            ),
            CustomTextField(
                controller: text,
                // onSendLocation: _sendLocation,
                onSend: () {
                  setState(() {
                    Chat.add(model_chat(text.text, myname));
                    text.clear();
                    //         });
                  });
                }
              // onSend: _sendMessage,

                  // Container(
                  //   padding: const EdgeInsets.all(15),
                  //   color: Colors.black87,
                  //   height: 100,
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: TextField(
                  //           controller:text ,
                  //
                  //           style: const TextStyle(
                  //             color: Colors.white,
                  //           ),
                  //
                  //         ),
                  //       ),
                  //       IconButton(onPressed: (){
                  //         setState(() {
                  //           Chat.add(model_chat(text.text,myname));
                  //           text.text="";
                  //         });
                  //       }, icon: const Icon(Icons.send,color: Colors.green,)),
                  //     ],
                  //   ),
                  // )
                  // ]
                 ),],
      ),),);
  }
}
