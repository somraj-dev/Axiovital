import 'package:flutter/material.dart';

class AccessHistoryPage extends StatelessWidget {
  const AccessHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Audit History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildAuditCard('VIEW', 'Dr. Alice Cooper viewed MRI Scan', 'Dec 12, 10:45 AM', 'TX: 0x8f...39a'),
          _buildAuditCard('GRANT', 'Granted Dr. Alice Cooper access', 'Dec 12, 10:40 AM', 'TX: 0x2e...11c'),
          _buildAuditCard('UPLOAD', 'Uploaded MRI Scan to IPFS', 'Oct 12, 09:00 AM', 'TX: 0x4a...92b'),
        ],
      ),
    );
  }

  Widget _buildAuditCard(String action, String desc, String time, String txHash) {
    Color actionColor = Colors.blue;
    if (action == 'UPLOAD') actionColor = Colors.green;
    if (action == 'GRANT') actionColor = Colors.purple;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: actionColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(action, style: TextStyle(color: actionColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              Row(
                children: [
                  const Icon(Icons.link, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(txHash, style: const TextStyle(fontSize: 12, color: Colors.grey, fontFamily: 'monospace')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(desc, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
