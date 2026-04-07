import 'package:flutter/material.dart';

class HealthTimelinePage extends StatelessWidget {
  const HealthTimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Health Timeline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildTimelineItem('Jan 12, 2024', 'Access Revoked', 'Revoked access for Dr. Smith from Blood Test', Colors.red),
          _buildTimelineItem('Dec 15, 2023', 'Record Uploaded', 'Uploaded Amoxicillin 500mg', Colors.green),
          _buildTimelineItem('Nov 05, 2023', 'Access Granted', 'Granted Dr. Alice access to MRI Scan', Colors.blue),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String date, String title, String desc, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4, bottom: 4),
              width: 16,
              height: 16,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            Container(width: 2, height: 60, color: Colors.grey.shade200),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(desc, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
