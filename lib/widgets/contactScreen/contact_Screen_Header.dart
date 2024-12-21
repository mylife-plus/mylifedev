import 'package:flutter/material.dart';

class ContactHeader extends StatelessWidget {
  const ContactHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFD665),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [

          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 16),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3D0),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: const Icon(Icons.arrow_back, size: 24),
              ),
              const SizedBox(width: 105),
              Row(
                children: const [
                  Icon(Icons.person, size: 27),
                  SizedBox(width: 4),
                  Text(
                    'Contact',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Kumbh Sans',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}