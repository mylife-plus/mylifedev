import 'package:flutter/material.dart';
import '../widgets/memoryHeaderSection.dart';
import '../widgets/newMemoryForm.dart';

class MemoryAddScreen extends StatelessWidget {
  const MemoryAddScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0, // No shadow
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.amber,
            padding: EdgeInsets.zero,
            child: const HeaderSection(),
          ),
          Expanded(
            child: Container(
              color: const Color(0xFFFFF2C5),
              child: MemoryForm(),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade100,
    );
  }
}