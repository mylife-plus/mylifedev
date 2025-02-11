import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_example/providers/locationProvider.dart';
import 'package:mapbox_maps_example/screens/LoginPage.dart';
import 'package:mapbox_maps_example/screens/addMemoryScreen.dart';
import 'package:mapbox_maps_example/screens/addNewContactScreen.dart';
import 'package:mapbox_maps_example/screens/homePage.dart';
import 'package:mapbox_maps_example/screens/memoryFeedScreen.dart';
import 'package:mapbox_maps_example/screens/singleContactScreen.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {


  WidgetsFlutterBinding.ensureInitialized();

  MapboxOptions.setAccessToken("sk.eyJ1Ijoib3V0YnVyc3Q5OSIsImEiOiJjbTR1ZWM0eXMwa3ZlMnBzZzU3MHFwa3hrIn0.q6hXu5HhQv_ZKEdXhvMbJQ");

  runApp(
    ProviderScope(child: MyLifeApp()));
}


class MyLifeApp extends ConsumerWidget {
  const MyLifeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.watch(locationGetterProvider);
    return MaterialApp(


        debugShowCheckedModeBanner: false,

        initialRoute: '/',
        routes: {


          "/": (BuildContext context) => Homepage(),
          "/newContact": (BuildContext context) => AddNewContactScreen(),
          "/login": (BuildContext context) => LoginPage(),
          "/memoryFeed": (BuildContext context) => MemoryFeedScreen(),
          "/addMemory": (BuildContext context) => MemoryAddScreen(),
        } ,

        onGenerateRoute: (settings){
          if (settings.name == "/singleContact"){
            return MaterialPageRoute(builder: (BuildContext context)=>SingleContactScreen(contact: settings.arguments as Contact));

          }
          else return null;
        },

        theme: ThemeData(

          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.black.withOpacity(0.5)),
          datePickerTheme: DatePickerThemeData(backgroundColor: Colors.white),
          timePickerTheme: TimePickerThemeData(backgroundColor: Colors.white),
          appBarTheme: AppBarTheme(
            elevation: 0,
          ),
        )) ;
  }
}
