import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'update_profile_page.dart';

class VitalsyncSettingsPage extends StatefulWidget {
  const VitalsyncSettingsPage({super.key});

  @override
  State<VitalsyncSettingsPage> createState() => _VitalsyncSettingsPageState();
}

class _VitalsyncSettingsPageState extends State<VitalsyncSettingsPage> {
  bool _triageSensitivity = true;
  bool _criticalAlerts = true;
  bool _smartReminders = false;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE), // Light clinical grey
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'VitalSync AI',
          style: TextStyle(color: Color(0xFF1D2939), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.black54), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: Colors.black54), onPressed: () {}),
        ],
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header Card
            _buildUserHeader(userProvider),
            const SizedBox(height: 32),

            // User Account Section
            _buildSectionHeader('USER ACCOUNT'),
            const SizedBox(height: 12),
            _buildSettingsContainer([
              _buildSettingsItem(
                icon: Icons.security, 
                title: 'Security', 
                subtitle: userProvider.isTwoFactorEnabled ? 'Two-factor authentication enabled' : 'Two-factor authentication and...', 
                color: const Color(0xFFE0F2FE), 
                iconColor: const Color(0xFF2E90FA)
              ),
              const Divider(height: 1),
              _buildSettingsItem(icon: Icons.lock_outline, title: 'Privacy & Data', subtitle: 'Manage how your clinical data...', color: const Color(0xFFE0F2FE), iconColor: const Color(0xFF2E90FA)),
              const Divider(height: 1),
              _buildSettingsItem(icon: Icons.wallet_outlined, title: 'Subscription', subtitle: 'Manage billing and plan details', color: const Color(0xFFE0F2FE), iconColor: const Color(0xFF2E90FA)),
            ]),

            const SizedBox(height: 32),

            // Health & AI Section
            _buildSectionHeader('HEALTH & AI'),
            const SizedBox(height: 12),
            _buildSettingsContainer([
              _buildSettingsItem(
                icon: Icons.psychology_outlined, 
                title: 'Digital Twin Settings', 
                subtitle: 'Status: ${userProvider.digitalTwinStatus}', 
                color: const Color(0xFFF0F9FF), 
                iconColor: const Color(0xFF2E90FA)
              ),
              const Divider(height: 1),
              _buildSwitchItem(icon: Icons.tune_rounded, title: 'Triage Sensitivity', subtitle: 'Set AI alert threshold levels', value: _triageSensitivity, color: const Color(0xFFF0F9FF), iconColor: const Color(0xFF2E90FA), onChanged: (v) => setState(() => _triageSensitivity = v)),
              const Divider(height: 1),
              _buildBadgeItem(
                icon: Icons.watch_outlined, 
                title: 'Wearable Sync', 
                subtitle: 'Connect Apple Health...', 
                badge: userProvider.wearableStatus, 
                color: const Color(0xFFF0F9FF), 
                iconColor: const Color(0xFF2E90FA)
              ),
            ]),

            const SizedBox(height: 32),

            // Notifications Section
            _buildSectionHeader('NOTIFICATIONS'),
            const SizedBox(height: 12),
            _buildSettingsContainer([
              _buildSwitchItem(icon: Icons.notifications_active_outlined, title: 'Critical Health Alerts', subtitle: 'Override silent mode for vital warnings', value: _criticalAlerts, color: const Color(0xFFEFF8FF), iconColor: const Color(0xFF2E90FA), onChanged: (v) => setState(() => _criticalAlerts = v)),
              const Divider(height: 1),
              _buildSwitchItem(icon: Icons.lightbulb_outline, title: 'Smart Reminders', subtitle: 'AI-optimized check-in notifications', value: _smartReminders, color: const Color(0xFFEFF8FF), iconColor: const Color(0xFF2E90FA), onChanged: (v) => setState(() => _smartReminders = v)),
            ]),

            const SizedBox(height: 32),

            // Support & About Section
            _buildSectionHeader('SUPPORT & ABOUT'),
            const SizedBox(height: 12),
            _buildSettingsContainer([
              _buildSettingsItem(icon: Icons.help_outline, title: 'Help Center', trailing: const Icon(Icons.open_in_new, size: 20, color: Color(0xFF2E90FA))),
              const Divider(height: 1),
              _buildSettingsItem(icon: Icons.gavel_outlined, title: 'Legal & HIPAA Privacy Policy'),
              const Divider(height: 1),
              _buildSettingsItem(icon: Icons.info_outline, title: 'About VitalSync v4.2.0'),
            ]),

            const SizedBox(height: 24),

            // Sign Out Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFFBFA),
                  foregroundColor: const Color(0xFFD92D20),
                  elevation: 0,
                  side: const BorderSide(color: Color(0xFFFEE4E2)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 100), // Bottom space for nav bar
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildUserHeader(UserProvider user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4), spreadRadius: -5)],
      ),
      child: Column(
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(user.avatarUrl),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.check_circle, color: Color(0xFF2E90FA), size: 18),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1D2939)),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFEFF8FF), borderRadius: BorderRadius.circular(4)),
                child: Text(user.membershipType, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2E90FA))),
              ),
              const SizedBox(width: 8),
              Text('Member since ${user.memberSince}', style: const TextStyle(fontSize: 12, color: Color(0xFF667085))),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateProfilePage())),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C111D),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Edit Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF475467), letterSpacing: 1.1),
    );
  }

  Widget _buildSettingsContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4), spreadRadius: -5)],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsItem({required IconData icon, required String title, String? subtitle, Color? color, Color? iconColor, Widget? trailing}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color ?? const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: iconColor ?? const Color(0xFF475467), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1D2939))),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF667085))) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Color(0xFFD0D5DD)),
    );
  }

  Widget _buildSwitchItem({required IconData icon, required String title, required String subtitle, required bool value, required Color color, required Color iconColor, required Function(bool) onChanged}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1D2939))),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF667085))),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF2E90FA),
      ),
    );
  }

  Widget _buildBadgeItem({required IconData icon, required String title, required String subtitle, required String badge, required Color color, required Color iconColor}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1D2939))),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF667085))),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: const Color(0xFFEFF8FF), borderRadius: BorderRadius.circular(6)),
        child: Text(badge, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF2E90FA))),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF2F4F7))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.favorite_border, 'HEALTH', false),
          _buildNavItem(Icons.psychology_outlined, 'TWIN', false),
          _buildNavItem(Icons.bar_chart_outlined, 'REPORTS', false),
          _buildNavItem(Icons.settings, 'SETTINGS', true),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isSelected ? const Color(0xFF2E90FA) : const Color(0xFF667085)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: isSelected ? const Color(0xFF2E90FA) : const Color(0xFF667085), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}
