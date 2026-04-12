import 'package:flutter/material.dart';

class AxioVerifiedBadge extends StatelessWidget {
  final double size;
  final Color color;

  const AxioVerifiedBadge({
    super.key, 
    this.size = 18.0,
    this.color = const Color(0xFF2E90FA), // Premium blue
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.check,
        color: Colors.white,
        size: size * 0.7,
      ),
    );
  }
}
