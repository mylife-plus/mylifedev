import 'package:flutter/material.dart';

class ContactSearch extends StatelessWidget {
  const ContactSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              const Icon(Icons.group, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Selected Contacts',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Dagobert Duck, Fa...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.close, size: 24),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          margin: const EdgeInsets.only(top: 5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.search, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Search',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2A2B2B),
                ),
              ),
              const Spacer(),
              const Icon(Icons.filter_list, size: 24),
              const SizedBox(width: 30),
              const Icon(Icons.add, size: 24),
            ],
          ),
        ),
      ],
    );
  }
}