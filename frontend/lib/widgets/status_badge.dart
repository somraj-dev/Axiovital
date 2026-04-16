import 'package:flutter/material.dart';
import '../models/medical_report.dart';

class StatusBadge extends StatelessWidget {
  final ReportStatus status;

  const StatusBadge({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String label;
    IconData? icon;

    switch (status) {
      case ReportStatus.verified:
        backgroundColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        label = 'Verified';
        break;
      case ReportStatus.critical:
        backgroundColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFC62828);
        label = 'Critical';
        break;
      case ReportStatus.locked:
        backgroundColor = const Color(0xFFF5F5F5);
        textColor = const Color(0xFF616161);
        label = 'Locked';
        icon = Icons.lock_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
