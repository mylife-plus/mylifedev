
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_example/screens/contactsScreen.dart';
import 'package:mapbox_maps_example/screens/memoryFeedScreen.dart';
import 'package:mapbox_maps_example/screens/settingsScreen.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'mapScreen.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> with SingleTickerProviderStateMixin {

  ScrollController controller = ScrollController();
  ScrollController mapScrollController = ScrollController();

  List tabs = [
    'assets/earth.png',
    'assets/book.png',
    'assets/user.png'
    'assets/cogwheel.png',
  ];

  late TabController _tabController;
  late MapboxMap map;
  @override
  void initState() {


    _tabController = TabController(length: 4, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

appBar: AppBar(
  backgroundColor: Colors.grey.shade100,
  elevation: 0,
  automaticallyImplyLeading: false,
  title: Container(
    height: 30,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.search, size: 32, color: Colors.grey),
            SizedBox(width: 12),
            Text(
              'Search',
              style:
              TextStyle(fontSize: 22, color: Colors.black54),
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.tune, size: 32, color: Colors.grey),
            SizedBox(width: 16),
            Icon(Icons.add, size: 32, color: Colors.grey),
          ],
        ),
      ],
    ),
  ),
),
      body: TabBarView(
        physics:NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            LayoutBuilder( builder:(BuildContext, constraints)=> SizedBox(width:constraints.maxWidth,height: constraints.maxHeight,child: MapWidget(onMapCreated: (mapbox)=>{map=mapbox}, gestureRecognizers: {
            Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
            ),
            },)),),
          MemoryFeedScreen(),
            ContactsScreen(),
            SettingsScreen(),

      ]

      ),
      bottomNavigationBar:

      TabBar(
          controller: _tabController,
          tabs:


          [
          ...tabs.map((e)=>Tab(child: Image.asset(e)))


          ]

      ),

    );
  }
}
