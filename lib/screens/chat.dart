import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chatting_app/constants/const.dart';
import 'package:chatting_app/models/model_chat.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/custom_app_bar2.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController text=TextEditingController();
  String myname='chat1';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar2(title: "Chat 1"),
      body: Container(
        color: Colors.white,
         child: Column(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: [
             // StreamBuilder<QuerySnapshot>(
             //   //Stream ..> htegy mnen el data class mn firebase feh el messages bt3tna
             //     stream: _firestore.collection('messages').snapshots(),
             //     builder: (context,snapshot){
             //       List<Text> messageWidgets=[]; // dy elli feha messages
             //        if (!snapshot.hasData)
             //          {
             //            return const Center(
             //              child: CircularProgressIndicator(),
             //            );
             //          }
             //        final messages=snapshot.data!.docs; // htdena document mn el data
             //        for(var message in messages){
             //          final messageText=message.get('text');
             //          final messageSender=message.get('sender');
             //          final messageWidget=Text('$messageText - $messageSender');
             //          messageWidgets.add(messageWidget);
             //        }
             //       return Column(
             //
             //         children: messageWidgets,
             //       );
             //     },
             // ),
             Expanded(
               child: ListView.builder(
                    itemCount: Chat.length,
                   itemBuilder: (_,index)=> BubbleSpecialThree(
                  text: Chat[index].text.toString(), // 3lshan mytl3sh instance of model
                  color: Chat[index].sender_name== myname ? Colors.green : Colors.blue,
                  isSender: Chat[index].sender_name== myname ? true : false,
                  tail: false, //heta gamb zay space
                  textStyle: TextStyle(
                      color: Chat[index].sender_name== myname ? Colors.white : Colors.black,
                      fontSize: 16),
                ),
                     ),
             ),
             Container(
               padding: const EdgeInsets.all(15),
               color: Colors.black87,
               height: 100,
               child: Row(
                 children: [
                   Expanded(
                     child: TextField(
                       controller:text ,
                       style: const TextStyle(
                         color: Colors.white,
                       ),

                     ),
                   ),
                   IconButton(onPressed: (){
                     setState(() {
                       Chat.add(model_chat(text.text,myname));
                       text.text="";
                     });
                   }, icon: const Icon(Icons.send,color: Colors.green,)),
                 ],
               ),
             )
           ],
         ),
    ),);
  }
}
