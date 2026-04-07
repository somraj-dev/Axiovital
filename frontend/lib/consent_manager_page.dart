import 'package:flutter/material.dart';

class ConsentManagerPage extends StatelessWidget {
  const ConsentManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Consent Hub', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Manage who can view your sensitive health data.', style: TextStyle(color: Color(0xFF667085))),
          const SizedBox(height: 24),
          _buildConsentCard('Dr. Alice Cooper', ['MRI Brain Scan', 'Blood Test Complete']),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
           // Show generate QR
        },
        backgroundColor: const Color(0xFF039855),
        icon: const Icon(Icons.qr_code, color: Colors.white),
        label: const Text('Generate Share Link', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildConsentCard(String doctor, List<String> records) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.security, color: Color(0xFF4A148C)),
                const SizedBox(width: 12),
                Text(doctor, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          const Divider(height: 1),
          for (var record in records)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(record, style: const TextStyle(fontSize: 14)),
                  Switch(
                    value: true,
                    activeColor: const Color(0xFF4A148C),
                    onChanged: (val) {},
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
