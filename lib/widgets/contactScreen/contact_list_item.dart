import 'package:flutter/material.dart';
import 'package:mapbox_maps_example/widgets/contactScreen/contct_mock.model.dart';

class ContactListItem extends StatelessWidget {
  final Contact contact;
  final VoidCallback onTap; // Callback to handle tap actions

  const ContactListItem({
    Key? key,
    required this.contact,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Trigger the callback when tapped
      child: Container(
        color: Colors.white, // Removed blue background
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Check if imageUrl is null or empty and display placeholder
              (contact.imageUrl != null && contact.imageUrl!.isNotEmpty)
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  contact.imageUrl!,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                ),
              )
                  : Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD665),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  contact.name[0].toUpperCase(), // Use the first letter of the name
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/share.png',
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          contact.type,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
