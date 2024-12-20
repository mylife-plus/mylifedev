import 'package:flutter/material.dart';
import 'package:mapbox_maps_example/widgets/contactScreen/contact_list_item.dart';
import 'package:mapbox_maps_example/widgets/contactScreen/contct_mock.model.dart';
import 'package:mapbox_maps_example/widgets/contactScreen/ContactDetailScreen.dart';

class ContactList extends StatelessWidget {
  final List<Contact> contacts;

  const ContactList({
    Key? key,
  })  : contacts = const [
    Contact(
      name: 'Dagobert Duck',
      type: 'Family',
      imageUrl: 'assets/dagobert.png',
      isSelected: false,
    ),
    Contact(
      name: 'Farm 2',
      type: 'Close Friend',
      imageUrl: 'assets/dagobert.png',
      isSelected: false,
    ),
    Contact(
      name: 'Farm 3',
      type: 'Friend',
      imageUrl: '',
      isSelected: false,
    ),
    Contact(
      name: 'Susi Mupsi',
      type: 'Travel, Friend',
      imageUrl: 'assets/dagobert.png',
      isSelected: true,
    ),
    Contact(
      name: 'Supasa Shahi',
      type: 'Close Friend',
      imageUrl: '',
      isSelected: false,
    ),
  ],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // Group contacts by the first letter of their name
    final Map<String, List<Contact>> groupedContacts = {};
    for (var contact in contacts) {
      final String firstLetter = contact.name[0].toUpperCase();
      if (!groupedContacts.containsKey(firstLetter)) {
        groupedContacts[firstLetter] = [];
      }
      groupedContacts[firstLetter]!.add(contact);
    }

    // Sort the group keys (letters) alphabetically
    final List<String> sortedKeys = groupedContacts.keys.toList()..sort();

    return ListView.builder(
      itemCount: sortedKeys.length,
      itemBuilder: (context, index) {
        final String letter = sortedKeys[index];
        final List<Contact> letterContacts = groupedContacts[letter]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Letter Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                letter,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Contacts under this letter
            ...letterContacts.map((contact) {
              return ContactListItem(
                contact: contact,
                onTap: () {
                  // Navigate to ContactDetailScreen on tap
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactDetailScreen(contact: contact),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        );
      },
    );
  }
}
