import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../providers/locationProvider.dart';

class MapScreen extends ConsumerStatefulWidget {



  const MapScreen({super.key});

  @override
  ConsumerState createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;


  late MapboxMap map;
  late Uint8List pinImage;
  late ByteData bytes;

  int index = 0;
  PointAnnotationManager? manager;
  bool isOffstage = true;
  Point currentPoint = Point(coordinates: Position(0, 0));
  Point iconPosition = Point(coordinates: Position(0, 0));
  PointAnnotation? annotation;
  bool isLocationChoosingMode = false;


  @override
  Widget build(BuildContext context) {
    super.build(context);
    final AsyncValue<List<double>> locationData = ref.watch(
        locationGetterProvider);


    return locationData.when(data: (location) {
      print("this is the location \n \n Find it below\n ");
      print(location);

      setState(() {
        iconPosition = Point(coordinates: Position(location[0], location[1]));
        currentPoint = Point(coordinates: Position(location[0], location[1]));
      });
      return Container(

        child: MapWidget(

          cameraOptions: CameraOptions(center: currentPoint),


          onTapListener: (e) async {
            if (isLocationChoosingMode) {
              setState(() {
                iconPosition = e.point;
              });

              manager?.delete(annotation!);

              annotation = await manager?.create(PointAnnotationOptions(
                  geometry: iconPosition,
                  image: pinImage,
                  iconSize: 0.15,
                  iconOffset: [0, -100]));
            }
          },


          onMapCreated: (mapbox) async {
            map = mapbox;
            map.scaleBar.updateSettings(ScaleBarSettings(enabled: false));
            map.logo.updateSettings(LogoSettings(enabled: false));
            map.attribution.updateSettings(AttributionSettings(enabled: false));
            manager = await map.annotations.createPointAnnotationManager();
            bytes =
            await rootBundle.load('assets/pin.png');
            pinImage = bytes.buffer.asUint8List();

            annotation = await manager?.create(PointAnnotationOptions(
                geometry: iconPosition, image: pinImage, iconSize: 0.15));
          },
          gestureRecognizers: {
            Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
            ),
          },
        ),
      );
    }, error: (e, s) => Container(), loading: () => Material(child: Container(
      child: Center(child: SizedBox(
          height: 100, width: 100, child: CircularProgressIndicator())),
      color: Colors.black,)));
  }
}