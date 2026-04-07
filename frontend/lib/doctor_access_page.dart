import 'package:flutter/material.dart';

class DoctorAccessPage extends StatelessWidget {
  const DoctorAccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          title: const Text('Doctor Access', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          bottom: const TabBar(
            labelColor: Color(0xFF101828),
            unselectedLabelColor: Color(0xFF667085),
            indicatorColor: Color(0xFF4A148C),
            tabs: [
              Tab(text: 'Pending Requests'),
              Tab(text: 'Active Permissions'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPendingTab(),
            _buildActiveTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildRequestCard('Dr. Sarah Jenkins', 'Cardiology', 'MRI Brain Scan', true),
        _buildRequestCard('Dr. Michael Chen', 'General Practice', 'Blood Test Complete', true),
      ],
    );
  }

  Widget _buildActiveTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildRequestCard('Dr. Alice Cooper', 'Neurology', 'MRI Brain Scan', false),
      ],
    );
  }

  Widget _buildRequestCard(String doctor, String specialty, String record, bool isPending) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: Colors.grey.shade200, child: const Icon(Icons.person, color: Colors.grey)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doctor, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(specialty, style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Icon(Icons.description, size: 16, color: Color(0xFF667085)),
                const SizedBox(width: 8),
                Text('Requested: $record', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (isPending)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A148C),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Approve'),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFEF3F2),
                  foregroundColor: const Color(0xFFD92D20),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Revoke Access'),
              ),
            ),
        ],
      ),
    );
  }
}
