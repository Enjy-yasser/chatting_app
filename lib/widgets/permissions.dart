import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionReq {
  Future<bool> checkPermissions(BuildContext context, Permission permission) async {
    final status = await permission.request(); // request permission
    if (status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Permission is granted"),
      ));
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Permission is not granted"),
      ));
      return false;
    }
  }
}