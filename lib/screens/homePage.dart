import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_example/screens/settingsScreen.dart';
import 'package:mapbox_maps_example/screens/testScreen.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'memoryFeedScreen.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> with SingleTickerProviderStateMixin {


  ScrollController controller = ScrollController();
  ScrollController mapScrollController = ScrollController();

  late PointAnnotationManager pointAnnotationManager;

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
            Container(
              key: PageStorageKey('map'),
              child: LayoutBuilder( builder:(BuildContext, constraints)=> SizedBox(width:constraints.maxWidth,height: constraints.maxHeight,child: Stack(
                children: [
                  MapWidget(
                    
                    onMapCreated: _onMapCreated, gestureRecognizers: {
                  Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                  ),
                  },),
              
              
              
                ],
              )),),
            ),
          MemoryFeedScreen(),
TestScreen(),

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


  _onMapCreated(MapboxMap mapbox) async {
    this.map = mapbox;
    pointAnnotationManager =
    await map.annotations.createPointAnnotationManager();

    // Load the image from assets
    final ByteData bytes =
    await rootBundle.load('assets/book.png');
    final Uint8List imageData = bytes.buffer.asUint8List();

    // Create a PointAnnotationOptions
    PointAnnotationOptions pointAnnotationOptions = PointAnnotationOptions(
        geometry: Point(coordinates: Position(-74.00913, 40.75183)), // Example coordinates
        image: imageData,
        iconSize: 0.2
    );

    // Add the annotation to the map
    final PointAnnotation annotation = await pointAnnotationManager.create(pointAnnotationOptions);

    pointAnnotationManager.addOnPointAnnotationClickListener(MarkerClickListener(onClick: (e){print('hello');}));

  }

}


class MarkerClickListener implements OnPointAnnotationClickListener {
  final Function(PointAnnotation) onClick;

  MarkerClickListener({required this.onClick});

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    onClick(annotation);
  }
}