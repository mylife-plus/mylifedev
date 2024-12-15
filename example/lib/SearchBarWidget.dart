import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.red,

        borderRadius: BorderRadius.circular(8),


      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [

              Icon(Icons.search, size: 28, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                'Search',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.tune, size: 28, color: Colors.grey),
              SizedBox(width: 12),
              Icon(Icons.add, size: 28, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}
