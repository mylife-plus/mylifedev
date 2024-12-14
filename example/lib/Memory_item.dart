import 'package:flutter/material.dart';
import 'package:mapbox_maps_example/point_annotations_example.dart';

class MemoryItem extends StatelessWidget {
  const MemoryItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.463,
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

  Widget _buildMemoryCircle(String text, Color color) {
    return Container(
      width: 30,
      height: 30,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.7),
            blurRadius: 4,
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Kumbh Sans',
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}