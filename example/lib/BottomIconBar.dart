import 'package:flutter/material.dart';

class BottomIconBar extends StatefulWidget {
  const BottomIconBar({Key? key}) : super(key: key);

  @override
  BottomIconBarState createState() => BottomIconBarState();
}

class BottomIconBarState extends State<BottomIconBar> {
  int _selectedIndex = 0;

  void _onIconTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIcon(0, 'assets/book.png'),
          _buildIcon(1, 'assets/earth.png'),
          _buildIcon(2, 'assets/cogwheel.png'),
          _buildIcon(3, 'assets/user.png'),
        ],
      ),
    );
  }

  // Helper method to build each icon
  Widget _buildIcon(int index, String asset) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onIconTapped(index),
      child: Container(
        width: MediaQuery.of(context).size.width*.25,
        height: MediaQuery.of(context).size.height*0.08,
        decoration: BoxDecoration(
          color: isSelected ? Colors.yellow : Colors.transparent,
        ),
        child: Center(
          child: Image.asset(
            asset,
            width: 50,
// Icon size
          ),
        ),
      ),
    );
  }
}