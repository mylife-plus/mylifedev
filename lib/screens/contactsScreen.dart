import 'package:flutter/material.dart';
import 'package:mapbox_maps_example/widgets/contactScreen/Contact_list.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3D0),
      body: const SafeArea(
        child: ContactList(), // No need for onContactTap here
      ),
    );
  }
}
