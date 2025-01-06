import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_example/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'newMemoryWidgetProvider.g.dart';

@Riverpod(keepAlive: true)
class Newmemorywidgetprovider extends _$Newmemorywidgetprovider {

  @override


@override
FutureOr<Map<String,dynamic>> build() async {

return {
  "selectedDate":DateTime.now(),
  "selectedTime": TimeOfDay.now(),
  "selectedContacts": [],
  "selectedHashtags":[],
  "selectedCoordinates":await determinePosition()
} ;
}

void changeTime(TimeOfDay time){
  
 state = state.whenData((data){

   return {
     ...data,
     "selectedTime":time
   };

  });
  
}


void changeDate(DateTime newDate) {
  state = state.whenData((currentMap) {
    return {
      ...currentMap,
      "selectedDate": newDate,
    };
  });
}

void changeContacts(List<String> newContacts) {
  state = state.whenData((currentMap) {
    return {
      ...currentMap,
      "selectedContacts": newContacts,
    };
  });
}

/// Replace the entire `selectedHashtags` list
void changeHashtags(List<String> newHashtags) {
  state = state.whenData((currentMap) {
    return {
      ...currentMap,
      "selectedHashtags": newHashtags,
    };
  });
}

/// Replace the `selectedCoordinates` list
/// You might want to add or remove items instead,
/// but here is how to replace the entire list.
void changeCoordinates(List<dynamic> newCoordinates) {
  state = state.whenData((currentMap) {
    return {
      ...currentMap,
      "selectedCoordinates": newCoordinates,
    };
  });
}










}