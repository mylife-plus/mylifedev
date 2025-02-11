import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_example/providers/hashtagsProvider.dart';
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

  List tabs = [
    'assets/earth.png',
    'assets/book.png',
    'assets/user.png',
    'assets/cogwheel.png',
  ];
  PointAnnotationManager? manager;
  bool isOffstage = true;
  Point currentPoint = Point(coordinates: Position(0, 0));
  Point iconPosition = Point(coordinates: Position(0, 0));
  PointAnnotation? annotation;
  bool isLocationChoosingMode = false;
  late TabController _tabController;
  late MapboxMap map;
  late Uint8List pinImage;
  late  ByteData bytes ;
  List<double> mapLocation=[0,0];


  @override
  void initState() {

    _tabController = TabController(length: 4, vsync: this);

    super.initState();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
   final AsyncValue<List<double>> locationData =  ref.watch(locationGetterProvider);

    var hashtags = ref.watch(hashtagNotifierProvider);


    return locationData.when(data: (location){

      setState(() {
        iconPosition = Point(coordinates: Position(location[0], location[1]));
        currentPoint = Point(coordinates: Position(location[0], location[1]));
      });

      return SafeArea(
        child: Stack(
          children: [
            Scaffold(
                resizeToAvoidBottomInset:false,
                key: scaffoldKey,
                extendBody: true,

                body: TabBarView(
                  dragStartBehavior: DragStartBehavior.down,
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
                                MapScreen( onTapListener: (e) async {

                                  ref.read(locationGetterProvider.notifier).changePosition([e.point.coordinates.lat.toDouble(),e.point.coordinates.lng.toDouble()]);


                        setState(() {
                        iconPosition = e.point;
                        mapLocation = [e.point.coordinates.lat.toDouble(),e.point.coordinates.lng.toDouble()];

                        });

                        print(e.point.coordinates.lat);
                        print(iconPosition.coordinates.lat);
                        print(mapLocation);

                        if(isLocationChoosingMode){
                          manager?.delete(annotation!);

                          annotation = await  manager?.create(PointAnnotationOptions(geometry: iconPosition, image: pinImage, iconSize: 0.2, iconOffset: [0,-100]));

                          setState(() {
                          });

                        }

                        }, onMapCreated: (mapbox) async {
                                  map = mapbox;
                                  map.logo.updateSettings(LogoSettings(enabled: false));
                                  map.attribution.updateSettings(AttributionSettings(enabled: false));
                                  map.scaleBar.updateSettings(ScaleBarSettings(enabled:false));
                                  map.compass.updateSettings(CompassSettings(enabled: false));
                                  manager = await map.annotations.createPointAnnotationManager();
                                   bytes =
                                  await rootBundle.load('assets/pin.png');
                                   pinImage = bytes.buffer.asUint8List();

                                  annotation = await  manager?.create(PointAnnotationOptions(geometry: iconPosition, image: pinImage, iconSize: 0.2, iconOpacity: 0));



                                }, ),
                                isLocationChoosingMode?Positioned(top: 20,left: 20,child: IconButton(onPressed: () async {

                                  if (isLocationChoosingMode){
                                    setState(() {
                                      iconPosition = Point(coordinates: Position(location[0], location[1]));
                                      currentPoint = Point(coordinates: Position(location[0], location[1]));
                                    });

                                    manager?.delete(annotation!);

                                    annotation = await  manager?.create(PointAnnotationOptions(geometry: iconPosition, image: pinImage, iconSize: 0.2, iconOffset: [0,-100]));

                                    await map.flyTo(CameraOptions(center: iconPosition), MapAnimationOptions());
                                  }

                                }, icon: Image.asset("assets/map.png", scale: 1.3,))):SizedBox.shrink(),
                                isLocationChoosingMode?Positioned(top: 20,right: 20,child: IconButton(onPressed: (){
                                  setState(() {
                                    isLocationChoosingMode=false;
                                    isOffstage=false;
                                  });
                                }, icon: Icon(grade: 0.5,Icons.check, color: Colors.white,size: 36,shadows: [Shadow(color: Colors.black, blurRadius: 9,)],))):SizedBox.shrink()
                              ],
                            )),
                      ),
                      MemoryFeedScreen(),
                      ContactsScreen(),
                      SettingsScreen(),
                    ]),
                floatingActionButton: !isLocationChoosingMode&&_tabController.index==0?FloatingActionButton(
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
                      location: [mapLocation.first,mapLocation.last], )),
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
