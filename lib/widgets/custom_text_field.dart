import 'package:chatting_app/widgets/permissions.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';


class CustomTextField extends StatelessWidget {
final TextEditingController controller;
final VoidCallback onSend;
final Function(String) onSendLocation;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onSendLocation,
  });

Future<void> _getCurrentLocation(BuildContext context) async{
  try {
    // hnkhod location permission
    final hasPermissions=await PermissionReq().checkPermissions(context,Permission.location);
    if(!hasPermissions)
    {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("Permission not granted"),backgroundColor: Colors.red,),
      );
      return;
    }
      Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
  );
    String googleMapsLink = "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";

    onSendLocation(googleMapsLink);

  // String currentLocationMessage = "Location : ${position.latitude},${position.longitude}";
  // onSendLocation(currentLocationMessage);

            }catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Error fetching location: $e'), backgroundColor: Colors.red),
  );
  }
}
 // const final List<Message> _messages = [];


@override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.black87,
      child: Row(
        children: [
          ElevatedButton(
            onPressed: ()=>_getCurrentLocation(context), style: ElevatedButton.styleFrom(backgroundColor: Colors.green,),
            child: const
                Icon(Icons.location_on,color: Colors.black,size: 20,),
            ),

          Expanded(
            child: TextField(
              controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
            hintText: 'Type your message...',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
                    ),
                  ),
          ),
      ElevatedButton(
        onPressed: onSend,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        child: const Icon(Icons.send,color: Colors.black,size: 20,),
      ),

      ],

      ),
    );
  }
}
