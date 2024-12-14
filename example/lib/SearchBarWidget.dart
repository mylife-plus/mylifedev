import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    size: 35,
                    color: Colors.black.withOpacity(0.8),
                  ),
                  const SizedBox(width: 12),
                  Semantics(
                    label: 'Search input field',
                    child: Text(
                      'Search',
                      style: TextStyle(
                        fontFamily: 'Kumbh Sans',
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2A2B2B).withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.tune, // Replace with settings/tuning icon
                  size: 35,
                  color: Colors.black.withOpacity(0.8),
                ),
                const SizedBox(width: 30),
                Icon(
                  Icons.add, // Replace with add/plus icon
                  size: 35,
                  color: Colors.black.withOpacity(0.8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

