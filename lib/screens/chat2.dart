// import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
// import 'package:chatting_app/widgets/custom_text_field.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../models/model_chat.dart';
// import '../widgets/custom_app_bar2.dart';
//
// class Chat2 extends StatefulWidget {
//
//   const Chat2({super.key});
//
//   @override
//   State<Chat2> createState() => _Chat2State();
// }
//
// class _Chat2State extends State<Chat2> {
//   TextEditingController text=TextEditingController();
//   String myname='Chat2';
//   List<model_chat> chat = []; // Initialize the chat list
//
//     void _sendLocation(String locationMessage) {
//       setState(() {
//         chat.add(model_chat(locationMessage, myname)); // Add location message to chat
//       });
//     }
//
//     Future<void> _openLink(String url)async{
//       Uri uri=Uri.parse(url);
//       if( await canLaunchUrl(uri))
//         {
//           await launchUrl(uri,mode:LaunchMode.externalApplication);
//         }
//       else{
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cannt open link")));
//       }
//     }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppBar2(title: "chat 2"),
//       body: Container(
//         color: Colors.white,
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: chat.length,
//                 itemBuilder: (_,index){
//                   final message=chat[index].text;
//                   final isLink=message.startsWith('https://');
//                   return GestureDetector(
//                     onTap: isLink ? ()=> _openLink(message): null,
//                     child:BubbleSpecialThree(
//                     text: message, // 3lshan mytl3sh instance of model
//                     color: chat[index].sender_name== myname ? Colors.green : Colors.blue,
//                     isSender: chat[index].sender_name== myname ? true : false,
//                     tail: true, //heta gamb zay space
//                     textStyle: TextStyle(
//                         color: chat[index].sender_name== myname ? Colors.white : Colors.black,
//                         fontSize: 16),
//                   ),);
//                   },
//                   ),
//                   ),
//                   CustomTextField(
//                   controller: text,
//                   onSendLocation: _sendLocation,
//                   onSend: () {
//                   setState(() {
//                     chat.add(model_chat(text.text, myname));
//                     text.clear();
//                     //         });
//                   });
//                 }
//             ),],
//           // onSend: _sendMessage,
//
//                   // Container(
//                   //   padding: const EdgeInsets.all(15),
//                   //   color: Colors.black87,
//                   //   height: 100,
//                   //   child: Row(
//                   //     children: [
//                   //       Expanded(
//                   //         child: TextField(
//                   //           controller:text ,
//                   //
//                   //           style: const TextStyle(
//                   //             color: Colors.white,
//                   //           ),
//                   //
//                   //         ),
//                   //       ),
//                   //       IconButton(onPressed: (){
//                   //         setState(() {
//                   //           chat.add(model_chat(text.text,myname));
//                   //           text.text="";
//                   //         });
//                   //       }, icon: const Icon(Icons.send,color: Colors.green,)),
//                   //     ],
//                   //   ),
//                   // )
//                   // ]
//       ),),);
//   }
// }
