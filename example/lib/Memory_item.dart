import 'package:flutter/material.dart';
import 'package:mapbox_maps_example/point_annotations_example.dart';

class MemoryItem extends StatelessWidget {
  const MemoryItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight, 
      child: Stack(
        children: [
          PointAnnotationExample(),

          Padding(
            padding: const EdgeInsets.fromLTRB(78, 172, 6, 172),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

            ),
          ),
        ],
      ),
    );
  }

 
}