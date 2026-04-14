import 'package:flutter/material.dart';
import '../../insurance_policy_model.dart';

class PolicyHighlightCard extends StatelessWidget {
  final PolicyHighlight highlight;

  const PolicyHighlightCard({super.key, required this.highlight});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: highlight.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: highlight.color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: highlight.color.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(highlight.icon, color: highlight.color, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            highlight.title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 15,
              color: Color(0xFF1D2939),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            highlight.subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                'Know more',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: highlight.color.computeLuminance() > 0.5 ? Colors.black87 : highlight.color,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 16, color: highlight.color),
            ],
          ),
        ],
      ),
    );
  }
}
