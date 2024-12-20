import 'package:flutter/material.dart';

class MemoryHeader extends StatelessWidget {
  final String date;
  final String country;
  final int reactions;

  const MemoryHeader({
    Key? key,
    required this.date,
    required this.country,
    required this.reactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today, size: screenWidth * 0.05), 
            SizedBox(width: screenWidth * 0.01), 
            Text(
              date,
              style: TextStyle(
                fontFamily: 'Kumbh Sans',
                fontSize: screenWidth * 0.045, 
                fontWeight: FontWeight.w500,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.location_on, size: screenWidth * 0.05),
            SizedBox(width: screenWidth * 0.01),
            Text(
              country,
              style: TextStyle(
                fontFamily: 'Kumbh Sans',
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),

        // Reactions Section
        Row(
          children: [
            Icon(Icons.person, size: screenWidth * 0.05),
            SizedBox(width: screenWidth * 0.01),
            Text(
              reactions.toString(),
              style: TextStyle(
                fontFamily: 'Kumbh Sans',
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            
          ],
        ),
      ],
    );
  }
}
