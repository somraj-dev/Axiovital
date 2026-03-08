import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  // Toggle states
  bool _criticalAlertsMaster = true;
  bool _pushNotifications = true;
  bool _smsAlerts = true;
  bool _phoneCalls = false;

  bool _clinicalUpdatesMaster = true;

  bool _quietHoursMaster = false;
  
  bool _caregiverSyncMaster = true;
  bool _nudgesEnabled = true;

  bool _dailyRemindersMaster = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notification Settings',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Critical Alerts Section
            _buildSectionHeader(
              icon: Icons.error_rounded,
              title: 'Critical Alerts',
              value: _criticalAlertsMaster,
              onChanged: (val) => setState(() => _criticalAlertsMaster = val),
              color: const Color(0xFFF04438),
            ),
            if (_criticalAlertsMaster) ...[
              _buildCriticalInfoCard(),
              _buildSettingTile(
                title: 'Push Notifications',
                value: _pushNotifications,
                onChanged: (val) => setState(() => _pushNotifications = val),
                showCheck: true,
              ),
              _buildSettingTile(
                title: 'SMS Emergency Alerts',
                value: _smsAlerts,
                onChanged: (val) => setState(() => _smsAlerts = val),
                showCheck: true,
              ),
              _buildSettingTile(
                title: 'Automated Phone Call',
                value: _phoneCalls,
                onChanged: (val) => setState(() => _phoneCalls = val),
              ),
            ],

            const SizedBox(height: 24),

            // Clinical Updates Section
            _buildSectionHeader(
              icon: Icons.medical_services_rounded,
              title: 'Clinical Updates',
              value: _clinicalUpdatesMaster,
              onChanged: (val) => setState(() => _clinicalUpdatesMaster = val),
              color: const Color(0xFF2E90FA),
            ),
            if (_clinicalUpdatesMaster) ...[
              _buildClinicalCard(),
            ],

            const SizedBox(height: 24),

            // Quiet Hours Section
            _buildSectionHeader(
              icon: Icons.nightlight_round,
              title: 'Quiet Hours',
              value: _quietHoursMaster,
              onChanged: (val) => setState(() => _quietHoursMaster = val),
              color: const Color(0xFF6172F3),
            ),
            if (_quietHoursMaster) ...[
              _buildQuietHoursCard(),
            ],

            const SizedBox(height: 24),

            // Caregiver Sync Section
            _buildSectionHeader(
              icon: Icons.people_rounded,
              title: 'Caregiver Sync',
              value: _caregiverSyncMaster,
              onChanged: (val) => setState(() => _caregiverSyncMaster = val),
              color: const Color(0xFF12B76A),
            ),
            if (_caregiverSyncMaster) ...[
              _buildCaregiverCard(),
            ],

            const SizedBox(height: 24),

            // Daily Reminders Section
            _buildSectionHeader(
              icon: Icons.calendar_today_rounded,
              title: 'Daily Reminders',
              value: _dailyRemindersMaster,
              onChanged: (val) => setState(() => _dailyRemindersMaster = val),
              color: const Color(0xFFF79009),
            ),
            if (_dailyRemindersMaster) ...[
              _buildRemindersCard(),
            ],

            const SizedBox(height: 40),
            
            // Save Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E90FA),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save Preferences',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1D2939)),
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeColor: const Color(0xFF2E90FA),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildCriticalInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFEE4E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Master Critical Overrides',
            style: TextStyle(color: Color(0xFFB42318), fontWeight: FontWeight.bold, fontSize: 13),
          ),
          SizedBox(height: 8),
          Text(
            'Urgent health flags bypass silent mode and "Do Not Disturb" to ensure immediate action.',
            style: TextStyle(color: Color(0xFFB42318), fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool showCheck = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF2F4F7)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF344054), fontWeight: FontWeight.w500, fontSize: 14)),
          Row(
            children: [
              if (showCheck && value)
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.check_circle, color: Color(0xFF2E90FA), size: 18),
                ),
              CupertinoSwitch(
                value: value,
                activeColor: const Color(0xFF2E90FA),
                onChanged: onChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClinicalCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF2F4F7)),
      ),
      child: Column(
        children: [
          _buildNestedTile(
            title: 'Doctor Messages',
            subtitle: 'Secure chats from your care team',
            icons: [Icons.notifications_none_rounded, Icons.mail_outline_rounded],
            activeIconIndex: 1, // Mail active in screenshot
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildNestedTile(
            title: 'Lab Results',
            subtitle: 'Notifications when reports are ready',
            icons: [Icons.notifications_active_rounded, Icons.mail_outline_rounded],
            activeIconIndex: 0, // Bell active in screenshot
          ),
        ],
      ),
    );
  }

  Widget _buildNestedTile({
    required String title,
    required String subtitle,
    required List<IconData> icons,
    required int activeIconIndex,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Color(0xFF667085), fontSize: 12)),
              ],
            ),
          ),
          ...List.generate(icons.length, (index) {
            final isActive = index == activeIconIndex;
            return Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Icon(
                icons[index],
                color: isActive ? const Color(0xFF2E90FA) : const Color(0xFF98A2B3),
                size: 20,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuietHoursCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF2F4F7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mute all non-essential alerts during rest.',
            style: TextStyle(color: Color(0xFF667085), fontSize: 12, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimeDisplay('STARTS', '10:00 PM'),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.arrow_forward_rounded, color: Color(0xFFD0D5DD)),
              ),
              _buildTimeDisplay('ENDS', '07:00 AM'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeDisplay(String label, String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF2F4F7)),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF667085), fontSize: 9, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(time, style: const TextStyle(color: Color(0xFF1D2939), fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildCaregiverCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF2F4F7)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Color(0xFFF8F9FE), shape: BoxShape.circle),
            child: const Icon(Icons.diamond_outlined, color: Color(0xFF6172F3), size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Nudges & Encouragement', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 4),
                Text('Family reminders to stay active', style: TextStyle(color: Color(0xFF667085), fontSize: 12)),
              ],
            ),
          ),
          CupertinoSwitch(
            value: _nudgesEnabled,
            activeColor: const Color(0xFF2E90FA),
            onChanged: (val) => setState(() => _nudgesEnabled = val),
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF2F4F7)),
      ),
      child: Column(
        children: [
          _buildReminderTile('Medication Intake', [Icons.smartphone_rounded, Icons.watch_rounded]),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _buildReminderTile('Vitals Logging (BP/Glucose)', [Icons.smartphone_rounded, Icons.watch_rounded], watchActive: true),
        ],
      ),
    );
  }

  Widget _buildReminderTile(String title, List<IconData> icons, {bool watchActive = false}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          ),
          Icon(icons[0], color: const Color(0xFF2E90FA), size: 18),
          const SizedBox(width: 16),
          Icon(icons[1], color: watchActive ? const Color(0xFF2E90FA) : const Color(0xFFD0D5DD), size: 18),
        ],
      ),
    );
  }
}
