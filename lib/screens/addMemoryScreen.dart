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
        toolbarHeight: 17,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.amber,
            child: const HeaderSection(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0), // Apply padding only to the

              child: MemoryForm(), // MemoryForm will now expand and take remaining space
            ),
          ),
        ],
      ),
      backgroundColor: Colors.amber,
    );
  }
}
