import 'package:flutter/material.dart';
import 'notification_settings_page.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE), // Light background matching screenshot
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Color(0xFF98A2B3), size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF98A2B3), size: 24),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationSettingsPage()),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1D2939),
                    letterSpacing: -0.5,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Mark all as read',
                    style: TextStyle(
                      color: Color(0xFF2E90FA),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Critical Alerts Section
            _buildSectionHeader('CRITICAL ALERTS', badge: '2 NEW'),
            const SizedBox(height: 16),
            _buildCriticalCard(
              icon: Icons.favorite,
              title: 'High Heart Rate Detected',
              time: '2m ago',
              description: 'Your resting heart rate exceeded 105 BPM for over 5 minutes. Please find a place to rest.',
              actionLabel: 'View Live Data',
              color: const Color(0xFFF04438), // Red
            ),
            const SizedBox(height: 16),
            _buildCriticalCard(
              icon: Icons.thermostat,
              title: 'Temperature Elevation',
              time: '1h ago',
              description: 'Mild fever detected (99.8°F). This matches your recovery profile markers.',
              buttons: ['Log Symptoms', 'Dismiss'],
              color: const Color(0xFFF79009), // Orange
            ),
            const SizedBox(height: 32),

            // Daily Health Plan Section
            _buildSectionHeader('DAILY HEALTH PLAN'),
            const SizedBox(height: 16),
            _buildStandardCard(
              icon: Icons.medication,
              title: 'Medication Reminder',
              time: 'Scheduled',
              description: '8:00 AM • Lisinopril (10mg)',
              actionLabel: 'Log Dose',
              color: const Color(0xFF2E90FA), // Blue
            ),
            const SizedBox(height: 16),
            _buildStandardCard(
              icon: Icons.show_chart,
              title: 'Blood Pressure Check',
              time: 'Today',
              description: 'Record your morning reading for accurate AI predictions.',
              actionLabel: '+ Start Reading',
              color: const Color(0xFF2E90FA),
              isOutlinedAction: true,
            ),
            const SizedBox(height: 32),

            // Administrative Section
            _buildSectionHeader('ADMINISTRATIVE'),
            const SizedBox(height: 16),
            _buildAdminCard(
              icon: Icons.calendar_today,
              title: 'Appointment Confirmed',
              time: '4h ago',
              description: 'Dr. Aris (Cardiology) • Tomorrow, 10:30 AM',
              buttons: ['Reschedule', 'Details'],
            ),
            const SizedBox(height: 16),
            _buildAdminCard(
              icon: Icons.description_outlined,
              title: 'Invoice Available',
              time: 'Yesterday',
              description: 'Monthly VitalSync AI premium subscription statement.',
              link: 'View Statement',
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? badge}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF98A2B3),
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        if (badge != null)
          Text(
            badge,
            style: const TextStyle(
              color: Color(0xFFF04438),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
      ],
    );
  }

  Widget _buildCriticalCard({
    required IconData icon,
    required String title,
    required String time,
    required String description,
    required Color color,
    String? actionLabel,
    List<String>? buttons,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border(left: BorderSide(color: color, width: 6)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(actionLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_outlined, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ),
          ],
          if (buttons != null) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade200),
                      backgroundColor: Colors.grey.shade50,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: Text(buttons[0], style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: color.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: Text(buttons[1], style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStandardCard({
    required IconData icon,
    required String title,
    required String time,
    required String description,
    required String actionLabel,
    required Color color,
    bool isOutlinedAction = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(description, style: const TextStyle(color: Colors.black54, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: isOutlinedAction
                ? OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: color),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: Text(actionLabel, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                  )
                : ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      elevation: 0,
                    ),
                    child: Text(actionLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminCard({
    required IconData icon,
    required String title,
    required String time,
    required String description,
    List<String>? buttons,
    String? link,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFFF2F4F7), shape: BoxShape.circle),
                child: Icon(icon, color: const Color(0xFF475467), size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(description, style: const TextStyle(color: Colors.black54, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          if (buttons != null) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade200),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('Reschedule', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade200),
                      backgroundColor: Colors.grey.shade50,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('Details', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ],
          if (link != null) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Row(
                children: [
                  Text(link, style: const TextStyle(color: Color(0xFF4A80F0), fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  const Icon(Icons.open_in_new, color: Color(0xFF4A80F0), size: 16),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
