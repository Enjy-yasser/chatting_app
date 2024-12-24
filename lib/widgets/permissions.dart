
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionReq{
  Future <bool> checkPermissions (BuildContext context,Permission permission) async{

    final status=await permission.request(); // request permission
    if(status.isGranted)
    {
      // var locationPermission = await Permission.location.request();
      // locationGranted = locationPermission.isGranted;
      // da law granted permision
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Permission is granted")));
      return true;
    }else{
      // da law granted permision
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Permission is not granted")),
      );
      return false;
    }
  }
}

/*
onPressed:(){
checkPermissions(Permission.location,context);

}
 */