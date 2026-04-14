import 'package:flutter/material.dart';
import '../../insurance_policy_model.dart';

class PolicyDocumentTile extends StatelessWidget {
  final PolicyDocument document;

  const PolicyDocumentTile({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        title: Text(
          document.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF1D2939),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.file_download_outlined, color: Color(0xFF12B76A), size: 20),
        ),
        onTap: () {
          // Mock download trigger
        },
      ),
    );
  }
}
