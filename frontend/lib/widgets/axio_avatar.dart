import 'package:flutter/material.dart';

class AxioAvatar extends StatelessWidget {
  final double radius;
  final String? imageUrl;
  final String name;

  const AxioAvatar({
    super.key,
    this.radius = 20,
    this.imageUrl,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFE5E7EB),
      backgroundImage: (imageUrl != null && imageUrl!.startsWith('http'))
          ? NetworkImage(imageUrl!)
          : null,
      child: (imageUrl == null || !imageUrl!.startsWith('http'))
          ? Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: radius * 0.8,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4B5563),
              ),
            )
          : null,
    );
  }
}
