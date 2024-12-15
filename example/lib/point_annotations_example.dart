import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Visibility;
import 'package:mapbox_maps_example/utils.dart';

import 'BottomIconBar.dart';
import 'Memory_content.dart';
import 'SearchBarWidget.dart';
import 'example.dart';

class PointAnnotationExample extends StatefulWidget implements Example {
  @override
  final Widget leading = const Icon(Icons.map);
  @override
  final String title = 'Point Annotations';
  @override
  final String? subtitle = null;

  const PointAnnotationExample({super.key});

  @override
  State<StatefulWidget> createState() => PointAnnotationExampleState();
}

class AnnotationClickListener extends OnPointAnnotationClickListener {
  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    print("onAnnotationClick, id: ${annotation.id}");
  }
}

class PointAnnotationExampleState extends State<PointAnnotationExample> {
  PointAnnotationExampleState();
  late ScrollController _scrollController;
  bool _isAppBarVisible = true;

  MapboxMap? mapboxMap;
  PointAnnotation? pointAnnotation;
  PointAnnotationManager? pointAnnotationManager;
  int styleIndex = 1;
  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    mapboxMap.setCamera(
      CameraOptions(
          center: Point(coordinates: Position(0, 0)), zoom: 1.7, pitch: 0),
    );
    mapboxMap.annotations.createPointAnnotationManager().then((value) async {
      pointAnnotationManager = value;
      final ByteData bytes =
          await rootBundle.load('assets/symbols/custom-icon.png');
      final Uint8List list = bytes.buffer.asUint8List();
      createOneAnnotation(list);
      var options = <PointAnnotationOptions>[];
      for (var i = 0; i < 5; i++) {
        options.add(
            PointAnnotationOptions(geometry: createRandomPoint(), image: list));
      }
      pointAnnotationManager?.createMulti(options);

      var carOptions = <PointAnnotationOptions>[];
      for (var i = 0; i < 20; i++) {
        carOptions.add(PointAnnotationOptions(
            geometry: createRandomPoint(), iconImage: "car-15"));
      }
      pointAnnotationManager?.createMulti(carOptions);
      pointAnnotationManager
          ?.addOnPointAnnotationClickListener(AnnotationClickListener());
    });
  }

  @override
  void initState() {
    super.initState();

    _setSystemUIOverlayStyle();
  }

  void createOneAnnotation(Uint8List list) {
    pointAnnotationManager
        ?.create(PointAnnotationOptions(
            geometry: Point(
                coordinates: Position(
              0.381457,
              6.687337,
            )),
            textField: "custom-icon",
            textOffset: [0.0, -2.0],
            textColor: Colors.red.value,
            iconSize: 1.3,
            iconOffset: [0.0, -5.0],
            symbolSortKey: 10,
            image: list))
        .then((value) => pointAnnotation = value);
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  void _setSystemUIOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black, // Status bar background color
        statusBarIconBrightness: Brightness.light, // Dark icons
        systemNavigationBarColor:
            Colors.black, // Navigation bar color (Android)
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  Widget _update() {
    return TextButton(
      child: Text('update a point annotation'),
      onPressed: () {
        if (pointAnnotation != null) {
          var point = pointAnnotation!.geometry;
          var newPoint = Point(
              coordinates: Position(
                  point.coordinates.lng + 1.0, point.coordinates.lat + 1.0));
          pointAnnotation?.geometry = newPoint;
          pointAnnotationManager?.update(pointAnnotation!);
        }
      },
    );
  }

  Widget _create() {
    return TextButton(
        child: Text('create a point annotation'),
        onPressed: () async {
          final ByteData bytes =
              await rootBundle.load('assets/symbols/custom-icon.png');
          final Uint8List list = bytes.buffer.asUint8List();
          createOneAnnotation(list);
        });
  }

  Widget _delete() {
    return TextButton(
      child: Text('delete a point annotation'),
      onPressed: () {
        if (pointAnnotation != null) {
          pointAnnotationManager?.delete(pointAnnotation!);
        }
      },
    );
  }

  Widget _deleteAll() {
    return TextButton(
      child: Text('delete all point annotations'),
      onPressed: () {
        pointAnnotationManager?.deleteAll();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ensure status bar remains white when the UI rebuilds

    return SafeArea(
      child: Scaffold(
        appBar: _isAppBarVisible
            ? AppBar(
                backgroundColor: Colors.grey.shade100,
                elevation: 0, // No shadow
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
              )
            : null,
        body: SafeArea(
          child: Stack(
            children: [
              // Map widget fills the screen
              Positioned.fill(
                child: MapWidget(
                  key: ValueKey("mapWidget"),
                  onMapCreated: _onMapCreated,
                ),
              ),
              // Draggable bottom sheet
              DraggableScrollableSheet(
                initialChildSize: 0.08, // Initial height (30% of the screen)
                minChildSize: 0.08, // Minimum height (20% of the screen)
                maxChildSize: 1, // Maximum height (80% of the screen)

                builder: (context, scrollController) {
                  Timer? _scrollDebounce;

                  return NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is UserScrollNotification) {
                        if (_scrollDebounce?.isActive ?? false) _scrollDebounce!.cancel();
                        _scrollDebounce = Timer(const Duration(milliseconds: 200), () {
                          if (scrollNotification.direction == ScrollDirection.reverse) {
                            setState(() => _isAppBarVisible = false);
                          } else if (scrollNotification.direction == ScrollDirection.forward) {
                            setState(() => _isAppBarVisible = true);
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
          ),
        ),
        bottomNavigationBar: Visibility(
          visible: _isAppBarVisible,
          child: const BottomIconBar(),
        ),
      ),
    );
  }
}
