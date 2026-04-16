import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'report_vault_page.dart';
import 'doctor_access_page.dart';
import 'consent_manager_page.dart';
import 'health_timeline_page.dart';
import 'emergency_card_page.dart';
import 'access_history_page.dart';

class HealthPassportPage extends StatelessWidget {
  const HealthPassportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Health Passport', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildNavCard(context, 'Records Vault', 'Decentralized storage', Icons.folder_shared, const ReportVaultPage(), const Color(0xFFE3F2FD), const Color(0xFF1565C0)),
                  _buildNavCard(context, 'Doctor Access', 'Manage requests', Icons.medical_services, const DoctorAccessPage(), const Color(0xFFF3E5F5), const Color(0xFF7B1FA2)),
                  _buildNavCard(context, 'Consent Hub', 'Revoke/Grant', Icons.privacy_tip, const ConsentManagerPage(), const Color(0xFFE8F5E9), const Color(0xFF2E7D32)),
                  _buildNavCard(context, 'Health Timeline', 'Chronological view', Icons.timeline, const HealthTimelinePage(), const Color(0xFFFFF3E0), const Color(0xFFEF6C00)),
                  _buildNavCard(context, 'Emergency Card', 'SOS profile', Icons.contact_emergency, const EmergencyCardPage(), const Color(0xFFFFEBEE), const Color(0xFFC62828)),
                  _buildNavCard(context, 'Audit History', 'Immutable logs', Icons.history, const AccessHistoryPage(), const Color(0xFFECEFF1), const Color(0xFF455A64)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7B3C8C), Color(0xFF4A148C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Icons.verified_user, color: Colors.white, size: 48),
          const SizedBox(height: 12),
          const Text(
            'Blockchain Verified',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 4),
          const Text(
            'Your medical data, cryptographically secured.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStat("14", "Records"),
              Container(width: 1, height: 30, color: Colors.white24),
              _buildStat("2", "Active Shares"),
              Container(width: 1, height: 30, color: Colors.white24),
              _buildStat("100%", "Verified"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStat(String val, String label) {
    return Column(
      children: [
        Text(val, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildNavCard(BuildContext context, String title, String subtitle, IconData icon, Widget page, Color bgColor, Color iconColor) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF101828))),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF667085))),
          ],
        ),
      ),
    );
  }
}
