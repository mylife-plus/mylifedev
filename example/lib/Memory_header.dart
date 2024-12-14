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
    return Row(
      children: [
        Row(
          children: [

            Icon(Icons.calendar_today, size: 20),
            const SizedBox(width: 4),
            Text(
              date,
              style: const TextStyle(
                fontFamily: 'Kumbh Sans',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                  decoration: TextDecoration.none

              ),
            ),
          ],
        ),
        const SizedBox(width: 18),
        Row(
          children: [
            Icon(Icons.location_on, size: 18),
            const SizedBox(width: 4),
            Text(
              country,
              style: const TextStyle(
                fontFamily: 'Kumbh Sans',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                  decoration: TextDecoration.none

              ),
            ),
          ],
        ),
        const SizedBox(width: 18),
        Row(
          children: [
            Icon(Icons.person, size: 20),
            const SizedBox(width: 4),
            Text(
              reactions.toString(),
              style: const TextStyle(
                fontFamily: 'Kumbh Sans',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black ,
              ),
            ),
          ],
        ),
      ],
    );
  }
}