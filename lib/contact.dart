import 'package:chatting_app/widgets/permissions.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<List<Contact>> getContacts(BuildContext context) async {
  try {
    final hasPermissions = await PermissionReq().checkPermissions(context, Permission.contacts);
    if (!hasPermissions) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Permission not granted"), backgroundColor: Colors.red),
      // );
      return [];
    }
    final contacts = await ContactsService.getContacts();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Contacts fetched successfully"), backgroundColor: Colors.green),
    );
    return contacts.toList();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching contacts: $e'), backgroundColor: Colors.red),
    );
    return [];
  }
}

