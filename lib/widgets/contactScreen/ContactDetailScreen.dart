import 'package:flutter/material.dart';
import 'contct_mock.model.dart';

class ContactDetailScreen extends StatelessWidget {
  final Contact contact;

  const ContactDetailScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Contact', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.amber,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: (contact.imageUrl?.isNotEmpty ?? false)
                        ? AssetImage(contact.imageUrl!)
                        : null,
                    child: (contact.imageUrl == null || contact.imageUrl!.isEmpty)
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        contact.type,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'XP 5,250', // Example static data, you can customize this
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.circle, color: Colors.green, size: 16),
                ],
              ),
            ),
            Container(
              color: Colors.amber.shade100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text('private', style: TextStyle(fontSize: 16)),
                  Text('public', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Our Memories'),
              trailing: const Text('3'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.auto_stories),
              title: const Text('First Memory'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.card_travel),
              title: Text(contact.type),
            ),
            ListTile(
              leading: const Icon(Icons.work),
              title: const Text('Programmer'),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Germany, Munich'),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('02398423048234'),
            ),
          ],
        ),
      ),
    );
  }
}
