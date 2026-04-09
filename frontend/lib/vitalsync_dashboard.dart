import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'widgets/axio_card.dart';
import 'user_provider.dart';
import 'vitals_service.dart';
import 'widgets/axio_avatar.dart';
import 'essentials_page.dart';
import 'fitleague_page.dart';
import 'device_connectivity_page.dart';
import 'search_page.dart';

class VitalSyncDashboard extends StatefulWidget {
  const VitalSyncDashboard({super.key});

  @override
  State<VitalSyncDashboard> createState() => _VitalSyncDashboardState();
}

class _VitalSyncDashboardState extends State<VitalSyncDashboard> {
  final VitalsService _vitalsService = VitalsService();
  Map<String, dynamic>? _latestVitals;
  List<dynamic> _vitalsHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVitalsData();
  }

  Future<void> _fetchVitalsData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.clinicalId;
    
    final latest = await _vitalsService.getLatestVitals(userId);
    final history = await _vitalsService.getVitalsHistory(userId);
    
    if (mounted) {
      setState(() {
        _latestVitals = latest;
        _vitalsHistory = history;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom Header to match screenshot
                _buildCustomHeader(context, userProvider),
                const SizedBox(height: 24),
                // Top Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Heart Rate',
                        '${_latestVitals?['heart_rate'] ?? '--'}',
                        'bpm',
                        Icons.favorite,
                        theme.primaryColor.withOpacity(0.1),
                        theme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Blood Pressure',
                        '${_latestVitals?['systolic_bp'] ?? '--'}/${_latestVitals?['diastolic_bp'] ?? '--'}',
                        'mmHg',
                        Icons.monitor_heart_outlined,
                        theme.primaryColor.withOpacity(0.1),
                        theme.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // SpO2 Stat (Single small card)
                _buildMedicationCard(
                  context,
                  'OXYGEN SATURATION',
                  'SpO2: ${_latestVitals?['spo2'] ?? '--'}%',
                  'Normal range: 95-100%',
                  Icons.air,
                  false,
                ),
                const SizedBox(height: 24),

                // Adherence Trends Card
                _buildTrendsCard(context),
                const SizedBox(height: 32),

                // Today's Schedule Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today's Schedule",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('See All', style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Active Medication Card example
                _buildMedicationCard(
                  context,
                  'UPCOMING • 8:00 PM',
                  'Atorvastatin - 10mg',
                  'After Dinner',
                  Icons.medication,
                  true,
                ),
                const SizedBox(height: 24),

                // Smart Reminders Toggle
                _buildReminderToggle(context),
                const SizedBox(height: 40),
              ],
            ),
          ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, String subValue, IconData icon, Color bgColor, Color accentColor) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontWeight: FontWeight.w600, fontSize: 13)),
              Icon(icon, color: accentColor, size: 18),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface),
              ),
              const SizedBox(width: 4),
              Text(
                subValue,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: accentColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendsCard(BuildContext context) {
    final theme = Theme.of(context);
    return AxioCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_graph, color: theme.primaryColor, size: 18),
              const SizedBox(width: 8),
              Text(
                'History Trends (Heart Rate)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: theme.colorScheme.onSurface),
              ),
            ],
          ),
          const SizedBox(height: 30),
          if (_vitalsHistory.isEmpty)
             const Center(child: Text("No data history available"))
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(_vitalsHistory.length > 7 ? 7 : _vitalsHistory.length, (index) {
                final item = _vitalsHistory[index];
                final hr = item['heart_rate'] as int;
                final date = DateTime.parse(item['timestamp']);
                final label = "${date.month}/${date.day}";
                return _buildBar(context, label, hr / 140); // Scaling to 140 bpm max for demo
              }),
            ),
        ],
      ),
    );
  }

  Widget _buildBar(BuildContext context, String label, double heightFactor) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          width: 32,
          height: 100 * heightFactor,
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface.withOpacity(0.4)),
        ),
      ],
    );
  }

  Widget _buildMedicationCard(BuildContext context, String status, String title, String instructions, IconData icon, bool isCurrent) {
    final theme = Theme.of(context);
    return AxioCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isCurrent ? theme.primaryColor : theme.colorScheme.onSurface.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    status,
                    style: TextStyle(
                      color: isCurrent ? theme.primaryColor : theme.colorScheme.onSurface.withOpacity(0.4),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: theme.primaryColor, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: 4),
          Text(
            instructions,
            style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontSize: 13),
          ),
          if (isCurrent) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                label: const Text(
                  'Mark as Resolved',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReminderToggle(BuildContext context) {
    final theme = Theme.of(context);
    return AxioCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.sensors, color: theme.primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Smart Reminders', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.onSurface)),
                Text('Location alerts & family nudges', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5), fontSize: 12)),
              ],
            ),
          ),
          CupertinoSwitch(
            value: true,
            onChanged: (v) {},
            activeColor: theme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context, UserProvider userProvider) {
    final theme = Theme.of(context);
    return Row(
      children: [
        AxioAvatar(
          radius: 20,
          imageUrl: userProvider.avatarUrl,
          name: userProvider.name,
          backgroundColor: const Color(0xFFFFB7CE), // Pinkish from screenshot
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 18),
              children: [
                const TextSpan(text: 'Hello '),
                TextSpan(
                  text: userProvider.name.split(' ').first,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search_rounded, size: 28),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, size: 28),
          onPressed: () {},
        ),
        _buildHamburgerMenu(context),
      ],
    );
  }

  Widget _buildHamburgerMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.menu_rounded, size: 24),
      ),
      offset: const Offset(0, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFF1F1F1F), // Dark background from screenshot
      onSelected: (value) => _handleMenuNavigation(context, value),
      itemBuilder: (context) => [
        _buildPopupMenuItem('Manage Diet', Icons.restaurant_menu),
        _buildPopupMenuItem('My Pocket', Icons.account_balance_wallet_outlined),
        _buildPopupMenuItem('Essentials', Icons.medical_services_outlined),
        _buildPopupMenuItem('Communities', Icons.groups_outlined),
        _buildPopupMenuItem('FitLeague', Icons.emoji_events_outlined, isNew: true),
        _buildPopupMenuItem('My Fitbit', Icons.watch_outlined),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(String title, IconData icon, {bool isNew = false}) {
    return PopupMenuItem<String>(
      value: title,
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          if (isNew) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'NEW',
                style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _handleMenuNavigation(BuildContext context, String value) {
    if (value == 'FitLeague') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const FitLeaguePage()));
    } else if (value == 'Essentials') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const EssentialsPage()));
    } else if (value == 'My Fitbit') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const DeviceConnectivityPage()));
    } else {
      // For items not yet implemented
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$value shortcut coming soon!')),
      );
    }
  }
}
