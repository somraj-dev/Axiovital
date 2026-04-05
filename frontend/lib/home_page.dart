import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'vitalsync_dashboard.dart';
import 'profile_drawer.dart';
import 'profile_page.dart';
import 'user_provider.dart';
import 'bluetooth_provider.dart';
import 'location_provider.dart';
import 'nutrition_page.dart';
import 'essentials_page.dart';
import 'fitleague_page.dart';
import 'search_page.dart';
import 'notification_page.dart';
import 'sleep_details_page.dart';
import 'widgets/axio_avatar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final btProvider = Provider.of<BluetoothProvider>(context);
    final locProvider = Provider.of<LocationProvider>(context);

    // Mock Dynamic Data
    String displayHr = btProvider.isConnected ? btProvider.heartRate.toString() : '72';

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF9FAFB),
      drawer: const ProfileDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _scaffoldKey.currentState?.openDrawer(),
                    child: AxioAvatar(
                      radius: 20,
                      imageUrl: userProvider.avatarUrl,
                      name: userProvider.name,
                    ),
                  ),
                  const Spacer(),
                  _buildHeaderIcon(
                    icon: Icons.search,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SearchPage()),
                      );
                    }
                  ),
                  const SizedBox(width: 12),
                  _buildHeaderIcon(
                    icon: Icons.notifications_none,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationPage()),
                      );
                    }
                  ),
                  const SizedBox(width: 12),
                  _buildPopupMenu(context),
                ],
              ),
              const SizedBox(height: 32),

              // Welcome Text
              Text(
                'Hi ${userProvider.name.split(' ')[0]}!',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF101828)),
              ),
              const Text(
                'Today is a great day to be healthy.',
                style: TextStyle(fontSize: 16, color: Color(0xFF667085), height: 1.5),
              ),
              const SizedBox(height: 32),

              // Health Metrics Section Header
              Row(
                children: [
                  const Text(
                    'Health Metrics',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF101828)),
                  ),
                  const Spacer(),
                  const Text(
                    'Last 7 days',
                    style: TextStyle(color: Color(0xFF667085), fontSize: 13),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 16, color: Colors.grey.shade400),
                ],
              ),
              const SizedBox(height: 16),

              // Metric Cards List
              _buildHealthMetricCard(
                icon: Icons.favorite,
                title: 'Sleeping Heart Rate',
                value: '$displayHr bpm',
                status: 'Normal',
                statusColor: const Color(0xFF12B76A),
                chartType: 'sparkline',
              ),
              _buildHealthMetricCard(
                icon: Icons.nightlight_round,
                title: 'Sleep Duration',
                value: '6h 36m',
                status: 'Normal',
                statusColor: const Color(0xFF12B76A),
                chartType: 'bars',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SleepDetailsPage()),
                  );
                },
              ),
              _buildHealthMetricCard(
                icon: Icons.monitor_heart_outlined,
                title: 'Heart Rate Variability',
                value: '31 ms',
                status: 'Low',
                statusColor: const Color(0xFFF79009),
                chartType: 'wave',
              ),
              _buildHealthMetricCard(
                icon: Icons.air,
                title: 'Respiratory Rate',
                value: '16,5 br/min',
                status: 'Normal',
                statusColor: const Color(0xFF12B76A),
                chartType: 'line',
              ),

              const SizedBox(height: 32),

              // Daily Recommendations Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daily recommendations',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  Text(
                    'See all',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Recommendation Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4), spreadRadius: -5),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(color: Color(0xFFDDF1F8), shape: BoxShape.circle),
                      child: const Icon(Icons.water_drop, color: Colors.black87, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Stay Hydrated!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          Text(
                            'Drink at least 2L of water today.',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHealthMetricCard({
    required IconData icon,
    required String title,
    required String value,
    required String status,
    required Color statusColor,
    required String chartType,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFF2F4F7)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF101828).withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 16, color: const Color(0xFF667085)),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF344054),
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.chevron_right, size: 16, color: Colors.grey.shade300),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF101828),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 13,
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 50,
                child: chartType == 'bars'
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(10, (index) {
                          final heights = [18.0, 24.0, 28.0, 36.0, 32.0, 22.0, 30.0, 38.0, 26.0, 20.0];
                          return Container(
                            width: 6,
                            height: heights[index],
                            decoration: BoxDecoration(
                              color: index == 7 ? const Color(0xFF101828) : const Color(0xFFF2F4F7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      )
                    : CustomPaint(
                        painter: chartType == 'sparkline'
                            ? _SparklinePainter(color: const Color(0xFF12B76A))
                            : chartType == 'wave'
                                ? _WavePainter(color: const Color(0xFFF79009))
                                : _LinePainter(color: const Color(0xFF12B76A)),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderIcon({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: _buildHeaderIconWidget(icon: icon),
    );
  }

  Widget _buildHeaderIconWidget({required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.black, size: 22),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        cardColor: const Color(0xFF2C2C2E),
      ),
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        offset: const Offset(0, 50),
        color: const Color(0xFF2C2C2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: _buildHeaderIconWidget(icon: Icons.menu),
        itemBuilder: (context) => [
          _buildPopupItem('Manage Diet'),
          _buildPopupItem('My Pocket'),
          _buildPopupItem('Essentials'),
          _buildPopupItem('Communities'),
          _buildPopupItem('FitLeague'),
          _buildPopupItem('My Fitbit'),
        ],
        onSelected: (value) {
          if (value == 'Manage Diet') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NutritionPage()),
            );
          } else if (value == 'Essentials') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EssentialsPage()),
            );
          } else if (value == 'FitLeague') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FitLeaguePage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$value is coming soon!'),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }

  PopupMenuItem<String> _buildPopupItem(String title) {
    return PopupMenuItem<String>(
      value: title,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final Color color;
  _SparklinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.lineTo(size.width * 0.1, size.height * 0.5);
    path.lineTo(size.width * 0.2, size.height * 0.6);
    path.lineTo(size.width * 0.3, size.height * 0.3);
    path.lineTo(size.width * 0.4, size.height * 0.5);
    path.lineTo(size.width * 0.5, size.height * 0.4);
    path.lineTo(size.width * 0.6, size.height * 0.6);
    path.lineTo(size.width * 0.7, size.height * 0.4);
    path.lineTo(size.width * 0.8, size.height * 0.5);
    path.lineTo(size.width * 0.9, size.height * 0.3);
    path.lineTo(size.width, size.height * 0.4);

    canvas.drawPath(path, paint);
    canvas.drawCircle(Offset(size.width, size.height * 0.4), 3, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LinePainter extends CustomPainter {
  final Color color;
  _LinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    path.moveTo(0, size.height * 0.5);
    for (var i = 1; i <= 10; i++) {
      path.lineTo(size.width * (i / 10), size.height * (0.4 + (i % 2 == 0 ? 0.2 : 0)));
    }
    canvas.drawPath(path, paint);

    final activePaint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2;
    final activePath = Path();
    activePath.moveTo(size.width * 0.8, size.height * 0.6);
    activePath.lineTo(size.width * 0.9, size.height * 0.4);
    activePath.lineTo(size.width, size.height * 0.5);
    canvas.drawPath(activePath, activePaint);
    canvas.drawCircle(Offset(size.width, size.height * 0.5), 3, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WavePainter extends CustomPainter {
  final Color color;
  _WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2;
    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.4, size.width * 0.4, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.9, size.width * 0.8, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.3, size.width, size.height * 0.7);
    canvas.drawPath(path, paint);
    canvas.drawCircle(Offset(size.width, size.height * 0.7), 3, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
