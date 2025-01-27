


import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Future<Position> determinePosition() async {


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
  return await Geolocator.getCurrentPosition();
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











