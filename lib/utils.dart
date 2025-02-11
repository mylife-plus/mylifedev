


import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';


String capitalize(String text){

  return text[0].toUpperCase()+text.substring(1);

}

Future<List<double>> determinePosition() async {




  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  Position position = await Geolocator.getCurrentPosition();
  return [position.longitude, position.latitude] ;
}

Future<void> checkAndRequestPermissions() async {
  // Request notification permission
  if (await Permission.notification.request().isDenied) {
    print("Notification permission denied");
  }

  // Request media permissions
  if (await Permission.audio.request().isDenied) {
    print("Audio permission denied");
  }
  if (await Permission.mediaLibrary.request().isDenied) {
    print("Media library permission denied");
  }
}


Future<List<Contact>> getAllContacts() async {

  if(! await Permission.contacts.isGranted){
    await Permission.contacts.request();
  }

  return FlutterContacts.getContacts();

}


String formatTime(TimeOfDay time){
  return "${time.hour<10?"0"+time.hour.toString():time.hour}:${time.minute<10?"0"+time.minute.toString():time.minute}";
}

String formatDate(DateTime date){
  return "${date.day<10?'0'+date.day.toString():date.day}/${date.month<10?'0'+date.month.toString():date.month}/${date.year}";
}

String formatPosition(Position position){
  return "${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}";
}











