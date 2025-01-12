import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_example/providers/locationProvider.dart';
import 'package:mapbox_maps_example/screens/contactsScreen.dart';
import 'package:mapbox_maps_example/screens/mapScreen.dart';
import 'package:mapbox_maps_example/screens/settingsScreen.dart';
import 'package:mapbox_maps_example/widgets/memoryScreen/newMemoryWidget.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'memoryFeedScreen.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage>
    with SingleTickerProviderStateMixin {


  int index = 0;
  PointAnnotationManager? manager;
  bool isOffstage = true;
  Point currentPoint = Point(coordinates: Position(0, 0));
  Point iconPosition = Point(coordinates: Position(0, 0));
  PointAnnotation? annotation;
  bool isLocationChoosingMode = false;
  List tabs = [
    'assets/earth.png',
    'assets/book.png',
    'assets/user.png',
    'assets/cogwheel.png',
  ];
  late TabController _tabController;
  late MapboxMap map;
  late Uint8List pinImage;
  late  ByteData bytes ;
  @override
  void initState() {

    _tabController = TabController(length: 4, vsync: this);

    super.initState();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

   final AsyncValue<List<double>> locationData =  ref.watch(locationGetterProvider);

    return locationData.when(data: (location){
      print("this is the location \n \n Find it below\n ");
      print(location);

      setState(() {
        iconPosition = Point(coordinates: Position(location[0], location[1]));
        currentPoint = Point(coordinates: Position(location[0], location[1]));
      });

      return SafeArea(
        child: Stack(
          children: [
            Scaffold(
                key: scaffoldKey,
                extendBody: true,
                body: TabBarView(
                    physics: _tabController.index == 0
                        ? NeverScrollableScrollPhysics()
                        : AlwaysScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      LayoutBuilder(
                        builder: (BuildContext, constraints) => SizedBox(
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            child: Stack(
                              children: [
                                MapScreen(),
                                isLocationChoosingMode?Positioned(top: 20,left: 20,child: IconButton(onPressed: () async {

                                  if (isLocationChoosingMode){
                                    setState(() {
                                      iconPosition = Point(coordinates: Position(location[0], location[1]));
                                      currentPoint = Point(coordinates: Position(location[0], location[1]));
                                    });

                                    manager?.delete(annotation!);

                                    annotation = await  manager?.create(PointAnnotationOptions(geometry: iconPosition, image: pinImage, iconSize: 0.15, iconOffset: [0,-100]));

                                  }

                                }, icon: Icon(Icons.location_on_outlined, size: 36, color: Colors.white,))):SizedBox.shrink(),
                                isLocationChoosingMode?Positioned(top: 20,right: 20,child: IconButton(onPressed: (){
                                  setState(() {
                                    isLocationChoosingMode=false;
                                    isOffstage=false;
                                  });
                                }, icon: Icon(Icons.check, color: Colors.white,size: 36,))):SizedBox.shrink()
                              ],
                            )),
                      ),
                      MemoryFeedScreen(),
                      ContactsScreen(),
                      SettingsScreen(),
                    ]),
                floatingActionButton: !isLocationChoosingMode?FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  elevation: 1,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    weight: 18,
                  ),
                  shape: CircleBorder(
                    side: BorderSide(color: Colors.white, width: 2),
                  ),
                  onPressed: () {
                    setState(() {
                      isOffstage = false;
                    });
                    ;
                  },
                ):null,
                floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterDocked,
                bottomNavigationBar: !isLocationChoosingMode?AnimatedBottomNavigationBar.builder(
                  elevation: 0,
                  notchSmoothness: NotchSmoothness.verySmoothEdge,
                  blurEffect: false,
                  backgroundColor: Colors.transparent,
                  gapWidth: 50,
                  gapLocation: GapLocation.center,
                  itemCount: 4,
                  tabBuilder: (int i, bool isActive) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: Image.asset(
                        tabs[i],
                        width: 36,
                        height: 36,
                      ),
                    );
                  },
                  activeIndex: index,
                  onTap: (requestedIndex) {
                    _tabController.animateTo(requestedIndex);
                    setState(() {
                      index = requestedIndex;
                    });
                  },
                ):null),
            Material(
              child: Offstage(
                offstage: isOffstage,
                child: Container(
                    width: double.infinity,
                    child: NewMemoryWidget(cancelCallback: () {
                      setState(() {
                        isOffstage = true;
                      });
                    },
                      locationCallback: _enterLocationSelectionMode,
                      location: [location.first,location.last],)),
              ),
            )
          ],
        ),
      );
    }, error: (e,s)=>Container(), loading: ()=>Material(child: Container(child: Center(child: SizedBox(height: 100,width: 100,child: CircularProgressIndicator())), color: Colors.black,))) ;
  }

  void _enterLocationSelectionMode(){
    setState(() {
      isLocationChoosingMode = true;
      isOffstage = true;
    });
  }
}
