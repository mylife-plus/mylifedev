import 'package:flutter/material.dart';

class InteractiveBottomSheetDraggableArea extends StatelessWidget {
  const InteractiveBottomSheetDraggableArea();

  @override
  Widget build(
      BuildContext context,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
        boxShadow:const [BoxShadow(color: Colors.grey, blurRadius: 1)],
      ),
      height: 40,
      child: Center(
        child: Container(
          height: 5,
          width: 5,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(
              Radius.circular(
                4,
              ),
            ),
          ),
        ),
      ),
    );
  }

}
