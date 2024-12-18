import 'package:flutter/material.dart';
import 'package:mapbox_maps_example/point_annotations_example.dart';

class MemoryItem extends StatefulWidget {
  const MemoryItem({super.key});

  @override
  MemoryItemState createState() => MemoryItemState();
}

class MemoryItemState extends State<MemoryItem> {
  bool _isInteracting = false;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.463,
      child: GestureDetector(
        onScaleStart: (_) {
          setState(() {
            _isInteracting = true; // Disable scrolling
          });
        },
        onScaleEnd: (_) {
          setState(() {
            _isInteracting = false; // Re-enable scrolling
          });
        },
        behavior: HitTestBehavior.translucent,
        child: AbsorbPointer(
          absorbing: _isInteracting, // Prevent CustomScrollView conflicts
          child: PointAnnotationExample(),
        ),
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