
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_example/screens/contactsScreen.dart';
import 'package:mapbox_maps_example/screens/memoryFeedScreen.dart';
import 'package:mapbox_maps_example/screens/settingsScreen.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../widgets/Memory_content.dart';
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
    'assets/user.png',
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
            IconButton(onPressed: ()=>{
              Navigator.of(context).pushNamed("/addMemory")
            },icon: Icon(Icons.add, size: 32, color: Colors.grey)),
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
            LayoutBuilder( builder:(BuildContext, constraints)=> SizedBox(width:constraints.maxWidth,height: constraints.maxHeight,child: Stack(
              children: [
                MapWidget(onMapCreated: (mapbox)=>{map=mapbox}, gestureRecognizers: {
                Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
                ),
                },),

                DraggableScrollableSheet(
                  initialChildSize: 0.08,
                  minChildSize: 0.08,
                  maxChildSize: 1,

                  builder: (context, scrollController) {
                    Timer? _scrollDebounce;

                    return NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification is UserScrollNotification) {
                          if (_scrollDebounce?.isActive ?? false) _scrollDebounce!.cancel();
                          _scrollDebounce = Timer(const Duration(milliseconds: 200), () {
                            if (scrollNotification.direction == ScrollDirection.reverse) {

                            } else if (scrollNotification.direction == ScrollDirection.forward) {

                            }
                          });
                        }

                        return false;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                        child: ListView(
                          controller: scrollController,
                          physics: const BouncingScrollPhysics(),

                          children: [
                            Container(
                              height: 58,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Center(
                                child: Container(
                                  height: 4,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              margin: EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  MemoryContent(
                                    date: "24/12/2024, 15:30",
                                    country: "Country Name",
                                    reactions: 3,
                                    content:
                                    "Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit ametLorem ipsum dolor sit amet Lorem ipsum dolor sit amet",
                                  ),
                                  const Divider(color: Colors.grey),
                                  MemoryContent(
                                    date: "24/12/2024, 15:30",
                                    country: "Country Name",
                                    reactions: 3,
                                    content: "Lorem ipsum dolor sit amet...",
                                    imageUrls: [
                                      "https://cdn.builder.io/api/v1/image/assets/TEMP/7632e90dad2f4f0ca39a4830dbb1b01d72906e4c0ddc67d230681b967b7cc622?placeholderIfAbsent=true&apiKey=c43da3a161eb4f318c4f96480fdf0876",
                                      "https://cdn.builder.io/api/v1/image/assets/TEMP/7632e90dad2f4f0ca39a4830dbb1b01d72906e4c0ddc67d230681b967b7cc622?placeholderIfAbsent=true&apiKey=c43da3a161eb4f318c4f96480fdf0876",
                                    ],
                                  ),
                                  const Divider(color: Colors.grey),
                                  MemoryContent(
                                    date: "24/12/2024, 15:30",
                                    country: "Country Name",
                                    reactions: 3,
                                    content:
                                    "Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit ametLorem ipsum dolor sit amet Lorem ipsum dolor sit amet",
                                    imageUrls: [
                                      "https://cdn.builder.io/api/v1/image/assets/TEMP/7632e90dad2f4f0ca39a4830dbb1b01d72906e4c0ddc67d230681b967b7cc622?placeholderIfAbsent=true&apiKey=c43da3a161eb4f318c4f96480fdf0876",
                                      "https://cdn.builder.io/api/v1/image/assets/TEMP/7632e90dad2f4f0ca39a4830dbb1b01d72906e4c0ddc67d230681b967b7cc622?placeholderIfAbsent=true&apiKey=c43da3a161eb4f318c4f96480fdf0876",
                                    ],
                                  ),
                                  const Divider(color: Colors.grey),
                                  MemoryContent(
                                    date: "24/12/2024, 15:30",
                                    country: "Country Name",
                                    reactions: 3,
                                    content:
                                    "i am the test dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit ametLorem ipsum dolor sit amet Lorem ipsum dolor sit amet",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

              ],
            )),),
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
