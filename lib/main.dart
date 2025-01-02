import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_example/screens/LoginPage.dart';
import 'package:mapbox_maps_example/screens/addMemoryScreen.dart';
import 'package:mapbox_maps_example/screens/homePage.dart';
import 'package:mapbox_maps_example/screens/memoryFeedScreen.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {

  const String ACCESS_TOKEN = String.fromEnvironment("ACCESS_TOKEN");

  WidgetsFlutterBinding.ensureInitialized();

  MapboxOptions.setAccessToken(ACCESS_TOKEN);

  runApp(
    ProviderScope(child: MyLifeApp()));
}













class MyLifeApp extends StatelessWidget {
  const MyLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(


      debugShowCheckedModeBanner: false,

      initialRoute: '/',
      routes: {


        "/": (BuildContext context) => Homepage(),
        "/login": (BuildContext context) => LoginPage(),
        "/memoryFeed": (BuildContext context) => MemoryFeedScreen(),
        "/addMemory": (BuildContext context) => MemoryAddScreen(),


      } ,
        theme: ThemeData(
        appBarTheme: AppBarTheme(
        elevation: 0,
    ),
    ));
  }
}

