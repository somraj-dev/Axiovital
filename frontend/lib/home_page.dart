import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'habit_tracker_page.dart';
import 'notification_page.dart';
import 'user_provider.dart';
import 'bluetooth_provider.dart';
import 'bluetooth_scan_page.dart';
import 'profile_page.dart';
import 'profile_drawer.dart';
import 'vitalsync_dashboard.dart';
import 'widgets/axio_avatar.dart';
import 'essentials_page.dart';
import 'fitleague_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  PopupMenuItem<String> _buildPopupItem(String title) {
    return PopupMenuItem<String>(
      value: title,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final btProvider = Provider.of<BluetoothProvider>(context);
    final String firstName = userProvider.name.split(' ').first;

    // Use BLE heart rate if connected, otherwise fallback to mock
    final int displayHr = (btProvider.isConnected && btProvider.heartRate > 0) ? btProvider.heartRate : 72;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF9F9F9), // Light grey background
      drawer: const ProfileDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        child: AxioAvatar(
                          radius: 18,
                          imageUrl: userProvider.avatarUrl,
                          name: userProvider.name,
                        ),
                      ),
                      const SizedBox(width: 12),
                      RichText(
                        text: TextSpan(
                          text: 'Hello ',
                          style: const TextStyle(color: Colors.black54, fontSize: 16),
                          children: [
                            TextSpan(
                              text: firstName,
                              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      if (btProvider.isConnected)
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.bluetooth_connected, color: Color(0xFF4B89FF), size: 16),
                        )
                    ],
                  ),
                  Row(
                    children: [
                      _buildHeaderIcon(
                        icon: Icons.notifications,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NotificationPage()),
                          );
                        },
                      ),
                      const SizedBox(width: 12), // Minimum gap as requested
                      _buildPopupMenu(context),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                'Here\'s your health\nat a glance',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                  letterSpacing: -0.5,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // Top row of metrics (Heart Rate & Steps)
              Row(
                children: [
                  // Heart Rate Card
                  Expanded(
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDDF1F8), // Light pale blue
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: const Icon(Icons.favorite, size: 16, color: Colors.black87),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('$displayHr bpm', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  const Text('Heart rate', style: TextStyle(color: Colors.black45, fontSize: 10)),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Mock Bar chart for Heartrate
                          SizedBox(
                            height: 60,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _HeartRateBar(height: 40, isThick: true),
                                _HeartRateBar(height: 50, isThick: false),
                                _HeartRateBar(height: 20, isThick: true),
                                _HeartRateBar(height: 40, isThick: false),
                                _HeartRateBar(height: 35, isThick: true),
                                _HeartRateBar(height: 60, isThick: false),
                                _HeartRateBar(height: 30, isThick: true),
                                _HeartRateBar(height: 45, isThick: false, isLight: true),
                                _HeartRateBar(height: 25, isThick: false, isLight: true),
                                _HeartRateBar(height: 35, isThick: true, isLight: true),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Steps Card
                  Expanded(
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFE1F8), // Pale purple
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                    child: const Icon(Icons.directions_walk, size: 16, color: Colors.black87),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text('2,200', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                      Text('Steps', style: TextStyle(color: Colors.black45, fontSize: 10)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Mock Line Wave chart
                            Positioned(
                              bottom: -10,
                              left: 0,
                              right: 0,
                              child: CustomPaint(
                                size: const Size(double.infinity, 80),
                                painter: _WavePainter(color: const Color(0xFFC3A5DF)), // Darker purple
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Sleep Card
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEBC7), // Pale green
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: const Icon(Icons.nightlight_round, size: 20, color: Colors.black87),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('9h 30m', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                            Text('Total sleep', style: TextStyle(color: Colors.black54, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Mock Bar chart for Sleep
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _SleepBar(height: 30, label: '6am'),
                        _SleepBar(height: 40, label: '7am'),
                        _SleepBar(height: 50, label: '8am'),
                        _SleepBar(height: 65, label: '9am'),
                        _SleepBar(height: 55, label: '10am'),
                        _SleepBar(height: 45, label: '11am', isSelected: true), // Dark highlighted bar
                        _SleepBar(height: 60, label: '12am'),
                        _SleepBar(height: 35, label: '1pm'),
                        _SleepBar(height: 25, label: '2pm'),
                      ],
                    ),
                  ],
                ),
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
        child: _buildHeaderIconWidget(icon: Icons.menu), // Use child instead of icon for better control
        itemBuilder: (context) => [
          _buildPopupItem('Manage Diet'),
          _buildPopupItem('My Pocket'),
          _buildPopupItem('Essentials'),
          _buildPopupItem('Communities'),
          _buildPopupItem('FitLeague'),
          _buildPopupItem('My Fitbit'),
        ],
        onSelected: (value) {
          if (value == 'Essentials') {
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
            // Show Coming Soon for other features
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
}

// Helper Widgets for the Mock Charts

class _HeartRateBar extends StatelessWidget {
  final double height;
  final bool isThick;
  final bool isLight;

  const _HeartRateBar({
    required this.height,
    required this.isThick,
    this.isLight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isThick ? 3 : 1.5,
      height: height,
      decoration: BoxDecoration(
        color: isLight ? Colors.black26 : Colors.black87,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final Color color;
  _WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill;
      
    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    
    // Create a bezier curve matching the screenshot wave
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.9, size.width * 0.4, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.5, size.width * 0.7, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.8, size.width, size.height * 0.4);
    
    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, paint);
    canvas.drawPath(path, linePaint);
    
    // Draw the dot on the graph
    final dotPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.6), 5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SleepBar extends StatelessWidget {
  final double height;
  final String label;
  final bool isSelected;

  const _SleepBar({
    required this.height,
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 24,
          height: height,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2C2C30) : const Color(0xFFCAE0B4), // Dark grey or light green
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 9,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
