import 'package:flutter/material.dart';

class MemoryReactions extends StatelessWidget {
  const MemoryReactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildReactionButton("📝"),
        _buildReactionButton("🥳"),
        _buildReactionButton("🏃"),
        _buildReactionButton("👨‍💻"),
      ],
    );
  }

  Widget _buildReactionButton(String emoji) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),

      ),
      child: Text(
        emoji,
        style: const TextStyle(
          fontSize: 25,
          fontFamily: 'Inter',
            decoration: TextDecoration.none
        ),
      ),
    );
  }
}