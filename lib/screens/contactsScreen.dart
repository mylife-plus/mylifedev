import 'package:flutter/material.dart';

import '../models/contact.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({Key? key}) : super(key: key);





  @override
  Widget build(BuildContext context) {
    final Map<String, List<Contact>> mockContacts = Contact.contactsListToMap();
    return Container(
      child: ListView(

        children: [
          ...mockContacts.keys.map((e) {
            return ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                ...mockContacts[e]!.map((element)=>Text(element.homeAddress))
            ],
            );
          })
        ],
      ),
    );
  }
}
