import 'package:flutter/material.dart';

class PolicySupportCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final String imagePath;
  final Color backgroundColor;

  const PolicySupportCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.imagePath,
    this.backgroundColor = const Color(0xFFEFF4FF),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1D2939),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        buttonText,
                        style: const TextStyle(
                          color: Color(0xFF0052CC),
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right, size: 20, color: Color(0xFF0052CC)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Image.network(
              imagePath,
              height: 120,
              fit: BoxFit.contain,
              errorBuilder: (context, _, __) => const Icon(Icons.support_agent, size: 80, color: Colors.blueGrey),
            ),
          ),
        ],
      ),
    );
  }
}
