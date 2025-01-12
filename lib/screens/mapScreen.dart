import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';


class MapScreen extends ConsumerStatefulWidget {

 final ValueChanged<MapContentGestureContext> onTapListener;
 final ValueChanged<MapboxMap> onMapCreated;
   MapScreen ({super.key,  required this.onTapListener, required this.onMapCreated});



  @override
  ConsumerState createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);

      return Container(
        child: MapWidget(
          cameraOptions: CameraOptions(),

          onTapListener: widget.onTapListener,
          onMapCreated: widget.onMapCreated,
          gestureRecognizers: {
            Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
            ),
          },
        ),
      );
    }

}