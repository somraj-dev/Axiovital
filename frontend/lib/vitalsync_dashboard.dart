import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'user_provider.dart';
import 'vitals_service.dart';
import 'widgets/axio_avatar.dart';
import 'essentials_page.dart';
import 'fitleague_page.dart';
import 'device_connectivity_page.dart';
import 'notification_page.dart';
import 'search_page.dart';
import 'profile_drawer.dart';
import 'cart_page.dart';
import 'cart_provider.dart';
import 'communities_page.dart';
import 'notification_provider.dart';

class VitalSyncDashboard extends StatefulWidget {
  const VitalSyncDashboard({super.key});

  @override
  State<VitalSyncDashboard> createState() => _VitalSyncDashboardState();
}

class _VitalSyncDashboardState extends State<VitalSyncDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
      key: _scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const ProfileDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Header row: Avatar + Hello Dr. + bell + hamburger
                    _buildHeader(context, userProvider),
                    const SizedBox(height: 24),

                    // "Here's your day at a glance"
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Here's your day\nat a glance",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: theme.colorScheme.onSurface,
                          height: 1.2,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Heart Rate + Blood Pressure cards row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          // Heart Rate Card (pink)
                          Expanded(
                            child: _buildHeartRateCard(context),
                          ),
                          const SizedBox(width: 12),
                          // Blood Pressure card (light purple)
                          Expanded(
                            child: _buildBloodPressureCard(context),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Sleep Card (green)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildSleepCard(context),
                    ),
                    const SizedBox(height: 32),

                    // Daily recommendations
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Daily recommendations',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'See all',
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Recommendation card: Stay Hydrated
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildRecommendationCard(
                        context,
                        icon: Icons.water_drop,
                        iconColor: const Color(0xFF4A90D9),
                        iconBgColor: const Color(0xFFE8F0FE),
                        title: 'Stay Hydrated!',
                        subtitle: 'Drink at least 2L of water today.',
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Recommendation card: Take a Walk
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildRecommendationCard(
                        context,
                        icon: Icons.directions_walk,
                        iconColor: const Color(0xFF4CAF50),
                        iconBgColor: const Color(0xFFE8F5E9),
                        title: 'Take a Walk!',
                        subtitle: 'Walk at least 10,000 steps today.',
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Recommendation card: Sleep Well
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildRecommendationCard(
                        context,
                        icon: Icons.bedtime,
                        iconColor: const Color(0xFF7C4DFF),
                        iconBgColor: const Color(0xFFF3E8FF),
                        title: 'Sleep Well!',
                        subtitle: 'Aim for 7-9 hours of quality sleep.',
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }

  // ─── HEADER ────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, UserProvider userProvider) {
    final theme = Theme.of(context);
    final firstName = userProvider.name.split(' ').first;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Avatar
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: AxioAvatar(
              radius: 20,
              imageUrl: userProvider.avatarUrl,
              name: userProvider.name,
              backgroundColor: const Color(0xFF8B5E6B), // Muted mauve from screenshot
            ),
          ),
          const SizedBox(width: 10),
          // Hello Dr.
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                    color: theme.colorScheme.onSurface, fontSize: 16),
                children: [
                  const TextSpan(text: 'Hello '),
                  TextSpan(
                    text: '$firstName.',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          // Search icon
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.search_rounded,
                  size: 22, color: theme.colorScheme.onSurface),
            ),
          ),

          // Notification bell
          Consumer<NotificationProvider>(
            builder: (context, notifProvider, _) => Row(
              children: [
                IconButton(
                  onPressed: () {
                    notifProvider.simulateNotification();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Simulated Appointment Added!')),
                    );
                  },
                  icon: const Icon(Icons.bug_report_outlined, color: Colors.blue, size: 20),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationPage()),
                    );
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.notifications_none_rounded,
                            size: 22, color: theme.colorScheme.onSurface),
                      ),
                      if (notifProvider.unreadCount > 0)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF04438),
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '${notifProvider.unreadCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Hamburger menu
          _buildHamburgerMenu(context),
        ],
      ),
    );
  }

  // ─── HEART RATE CARD (pink) ────────────────────────────────────────
  Widget _buildHeartRateCard(BuildContext context) {
    final heartRate = _latestVitals?['heart_rate'] ?? 72;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE4EC), // Light pink
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heart icon + value
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite, color: Colors.white, size: 14),
              ),
              const SizedBox(width: 8),
              Text(
                '$heartRate bpm',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Heart rate',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          // Bar chart visualization
          SizedBox(
            height: 60,
            child: _buildHeartRateBars(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeartRateBars() {
    // Bar heights simulating heart rate variation (like the screenshot)
    final List<double> barHeights = [
      0.7, 0.85, 0.6, 0.9, 0.5, 0.75, 0.65, 0.8, 0.55, 0.7,
      0.45, 0.6, 0.8, 0.5, 0.7,
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: barHeights.map((h) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Container(
              height: 60 * h,
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─── BLOOD PRESSURE CARD (light purple) ────────────────────────────
  Widget _buildBloodPressureCard(BuildContext context) {
    final systolic = _latestVitals?['systolic_bp'] ?? 120;
    final diastolic = _latestVitals?['diastolic_bp'] ?? 80;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5), // Light purple/lavender
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF9C27B0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.monitor_heart_outlined,
                    color: Colors.white, size: 14),
              ),
              const SizedBox(width: 8),
              Text(
                '$systolic/$diastolic',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Blood pressure',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          // Wave visualization
          SizedBox(
            height: 60,
            child: CustomPaint(
              size: const Size(double.infinity, 60),
              painter: _WavePainter(color: const Color(0xFF9C27B0)),
            ),
          ),
        ],
      ),
    );
  }

  // ─── SLEEP CARD (green) ────────────────────────────────────────────
  Widget _buildSleepCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9), // Light green
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Moon icon + sleep time
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.nightlight_round,
                    color: Color(0xFF2E7D32), size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '9h 30m',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  Text(
                    'Total sleep',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Sleep bar chart
          SizedBox(
            height: 80,
            child: _buildSleepBars(),
          ),
          const SizedBox(height: 8),
          // Time labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['6am', '7am', '8am', '9am', '10am', '11am', '12am', '1pm', '2pm']
                .map((t) => Text(
                      t,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepBars() {
    // Bar heights matching the screenshot pattern (11am is tallest/darkest)
    final List<Map<String, dynamic>> bars = [
      {'height': 0.55, 'dark': false},
      {'height': 0.50, 'dark': false},
      {'height': 0.60, 'dark': false},
      {'height': 0.50, 'dark': false},
      {'height': 0.55, 'dark': false},
      {'height': 1.0, 'dark': true},   // 11am - tallest, dark
      {'height': 0.45, 'dark': false},
      {'height': 0.50, 'dark': false},
      {'height': 0.55, 'dark': false},
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: bars.map((bar) {
        final isDark = bar['dark'] as bool;
        final h = bar['height'] as double;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Container(
              height: 80 * h,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFFA5D6A7).withOpacity(0.7),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─── RECOMMENDATION CARD ───────────────────────────────────────────
  Widget _buildRecommendationCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon circle
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          // Chevron
          Icon(
            Icons.chevron_right,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
            size: 22,
          ),
        ],
      ),
    );
  }

  // ─── HAMBURGER MENU ────────────────────────────────────────────────
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
        _buildPopupMenuItem('FitLeague', Icons.emoji_events_outlined),
        _buildPopupMenuItem('My Fitbit', Icons.watch_outlined),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(String title, IconData icon) {
    return PopupMenuItem<String>(
      value: title,
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _handleMenuNavigation(BuildContext context, String value) {
    if (value == 'FitLeague') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const FitLeaguePage()));
    } else if (value == 'Communities') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const CommunitiesPage()));
    } else if (value == 'Essentials') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const EssentialsPage()));
    } else if (value == 'My Fitbit') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const DeviceConnectivityPage()));
    } else {
      // For items not yet implemented
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$value shortcut coming soon!')),
      );
    }
  }
}

// ─── WAVE PAINTER for Blood Pressure ─────────────────────────────────
class _WavePainter extends CustomPainter {
  final Color color;
  _WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.5);

    for (double x = 0; x <= size.width; x += 1) {
      final y = size.height * 0.5 +
          math.sin(x * 0.08) * 15 +
          math.sin(x * 0.04) * 8;
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
