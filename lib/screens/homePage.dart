import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interactive_bottom_sheet/interactive_bottom_sheet.dart';
import 'package:mapbox_maps_example/screens/contactsScreen.dart';
import 'package:mapbox_maps_example/screens/settingsScreen.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../widgets/memoryScreen/newMemoryWidget.dart';
import 'memoryFeedScreen.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage>
    with SingleTickerProviderStateMixin {
  int index = 0;

  ScrollController controller = ScrollController();
  ScrollController mapScrollController = ScrollController();

  List tabs = [
    'assets/earth.png',
    'assets/book.png',
    'assets/user.png',
    'assets/cogwheel.png',
  ];
  bool modalOpened = false;
  late TabController _tabController;
  late MapboxMap map;
  late DraggableScrollableController sheetController;
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    sheetController= DraggableScrollableController();
    super.initState();
  }
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey sheetKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      extendBody: true,
        body: TabBarView(
            physics: _tabController.index==0?NeverScrollableScrollPhysics():AlwaysScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              LayoutBuilder(
                builder: (BuildContext, constraints) => SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: Stack(
                      children: [
                        MapWidget(

                          onMapCreated: (mapbox) => {map = mapbox},
                          gestureRecognizers: {
                            Factory<OneSequenceGestureRecognizer>(
                              () => EagerGestureRecognizer(),
                            ),
                          },
                        ),
                      ],
                    )),
              ),
              MemoryFeedScreen(),
              ContactsScreen(),
              SettingsScreen(),
            ]),
        bottomSheet: InteractiveBottomSheet(controller: sheetController, options: InteractiveBottomSheetOptions(initialSize: 0.2, minimumSize: 0.1,maxSize: 0.9) , child: NewMemoryWidget(),),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 1,
                  child: Icon(

                    Icons.add,
                    color: Colors.white,
                    weight: 18,

                  ),
          shape: CircleBorder(
            side: BorderSide(color: Colors.white, width: 2),
          ), onPressed: () {
          sheetController.jumpTo(0.7);
        },
        ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.miniCenterDocked,

        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          elevation: 0,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          blurEffect: false,
          backgroundColor: Colors.transparent,
          gapWidth: 50,
          gapLocation: GapLocation.center,
          itemCount: 4,
          tabBuilder: (int i, bool isActive) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
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
        )

        // BottomNavigationBar(
        //   elevation: 1,
        //   type: BottomNavigationBarType.fixed,
        //     onTap: (requestedIndex){ _tabController.animateTo(requestedIndex);
        //     setState(() {
        //       index = requestedIndex;
        //     });
        //
        //     },
        //     currentIndex: index,
        //
        //
        //     items: [
        //
        //     ...tabs.map((e)=>BottomNavigationBarItem(label: "",icon: ))
        //
        // ])

        );
  }
}

