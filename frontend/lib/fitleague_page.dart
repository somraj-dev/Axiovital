import 'dart:math' as math;
import 'package:flutter/material.dart';

class FitLeaguePage extends StatefulWidget {
  const FitLeaguePage({super.key});

  @override
  State<FitLeaguePage> createState() => _FitLeaguePageState();
}

class _FitLeaguePageState extends State<FitLeaguePage> {
  int _selectedTabIndex = 1; // Challenges selected by default
  String _selectedFilter = 'Run';

  final List<String> _tabs = ['Active', 'Challenges', 'Clubs'];
  final List<Map<String, dynamic>> _filters = [
    {'name': 'Run', 'icon': Icons.directions_run},
    {'name': 'Ride', 'icon': Icons.directions_bike},
    {'name': 'Swim', 'icon': Icons.pool},
    {'name': 'Walk', 'icon': Icons.directions_walk},
  ];

  // All challenges data matching the screenshots
  final List<Map<String, String>> _recommendedChallenges = [
    {
      'title': 'April 400-minute x Runna Challenge',
      'description': 'Complete 400 mins of activity in April - any sport counts!',
      'date': 'Apr 1 to Apr 30, 2026',
      'badge': '400\'',
      'type': 'run',
    },
    {
      'title': 'HOKA Speedgoat 7 Vert Challenge',
      'description': 'Log 7,000 feet (2,134 meters) of elevation gain',
      'date': 'Apr 9 to May 8, 2026',
      'badge': 'HOKA',
      'type': 'hike',
    },
  ];

  final List<Map<String, String>> _allChallenges = [
    {
      'title': 'April 5K x Brooks Challenge',
      'description': 'Complete a 5 km (3.1 mi) run.',
      'date': 'Apr 1 to Apr 30, 2026',
      'badge': '5K',
      'type': 'run',
    },
    {
      'title': 'April Ten Days Active Challenge',
      'description': 'Do 10 minutes of activity for 10 days this month. Any activity counts!',
      'date': 'Apr 1 to Apr 30, 2026',
      'badge': '10x',
      'type': 'walk',
    },
    {
      'title': 'April 180 Minute Sweat Challenge',
      'description': 'Complete a single activity that is 180-minutes long',
      'date': 'Apr 1 to Apr 30, 2026',
      'badge': '180\'',
      'type': 'run',
    },
    {
      'title': 'April Ride 200K Challenge',
      'description': 'Bike a total of 200 km (124.3 mi) in April.',
      'date': 'Apr 1 to Apr 30, 2026',
      'badge': '200K',
      'type': 'ride',
    },
    {
      'title': 'April Gran Fondo Challenge',
      'description': 'Complete a 100 km (62.1 mi) ride.',
      'date': 'Apr 1 to Apr 30, 2026',
      'badge': '100K',
      'type': 'ride',
    },
    {
      'title': 'April Elevation Challenge',
      'description': 'Climb a total of 2,000 m (6,561.7 ft) in April.',
      'date': 'Apr 1 to Apr 30, 2026',
      'badge': '2000M',
      'type': 'hike',
    },
    {
      'title': 'April Run 100K Challenge',
      'description': 'Run a total of 100 km (62.1 mi) in April.',
      'date': 'Apr 1 to Apr 30, 2026',
      'badge': '100K',
      'type': 'run',
    },
    {
      'title': 'April 10K Challenge',
      'description': 'Complete a 10 km (6.2 mi) run.',
      'date': 'Apr 1 to Apr 30, 2026',
      'badge': '10K',
      'type': 'run',
    },
    {
      'title': 'April Cycling 7000M Challenge',
      'description': 'Cycle a total of 7,000 m elevation in April.',
      'date': 'Apr 1 to Apr 30, 2026',
      'badge': '7000M',
      'type': 'ride',
    },
    {
      'title': 'April Ride 800K Challenge',
      'description': 'Bike a total of 800 km in April.',
      'date': 'Apr 1 to Apr 30, 2026',
      'badge': '800K',
      'type': 'ride',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            // Tabs
            _buildTabs(),
            const SizedBox(height: 12),
            // Content
            Expanded(
              child: _buildChallengesContent(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Groups',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    letterSpacing: -0.5,
                  ),
                ),
                if (_selectedTabIndex == 1)
                  const Text(
                    'Challenges',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          // Action icons
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 24),
            onPressed: () {},
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 24),
                onPressed: () {},
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF4D00),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTabIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTabIndex = index),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _tabs[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white54,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFF5722) : Colors.transparent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildChallengesContent() {
    if (_selectedTabIndex == 0) {
      return _buildActiveContent();
    } else if (_selectedTabIndex == 2) {
      return _buildClubsContent();
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Chips
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (context, index) => _buildFilterChip(_filters[index]),
            ),
          ),
          const SizedBox(height: 24),

          // Recommended For You section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person_pin_circle_outlined, color: Colors.white60, size: 24),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended For You',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Based on your activities',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Recommended challenges grid (2 cards)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(child: _buildChallengeCard(_recommendedChallenges[0])),
                const SizedBox(width: 12),
                Expanded(child: _buildChallengeCard(_recommendedChallenges[1])),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // All challenges in 2-column grid
          ..._buildChallengeGrid(_allChallenges),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  List<Widget> _buildChallengeGrid(List<Map<String, String>> challenges) {
    final List<Widget> rows = [];
    for (int i = 0; i < challenges.length; i += 2) {
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
          child: Row(
            children: [
              Expanded(child: _buildChallengeCard(challenges[i])),
              const SizedBox(width: 12),
              if (i + 1 < challenges.length)
                Expanded(child: _buildChallengeCard(challenges[i + 1]))
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    }
    return rows;
  }

  Widget _buildChallengeCard(Map<String, String> challenge) {
    final badge = challenge['badge'] ?? '';
    final type = challenge['type'] ?? 'run';

    // Choose icon based on type
    IconData typeIcon;
    switch (type) {
      case 'ride':
        typeIcon = Icons.directions_bike;
        break;
      case 'swim':
        typeIcon = Icons.pool;
        break;
      case 'walk':
        typeIcon = Icons.directions_walk;
        break;
      case 'hike':
        typeIcon = Icons.terrain;
        break;
      default:
        typeIcon = Icons.directions_run;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge icon
          _buildBadgeIcon(badge),
          const SizedBox(height: 14),

          // Title
          Text(
            challenge['title'] ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),

          // Activity type icon
          Icon(typeIcon, color: Colors.white54, size: 18),
          const SizedBox(height: 8),

          // Description
          Text(
            challenge['description'] ?? '',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white60, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 4),

          // Date
          Text(
            challenge['date'] ?? '',
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
          const SizedBox(height: 16),

          // Join Button
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                _showJoinedSnackbar(challenge['title'] ?? '');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4D00),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Join',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeIcon(String badge) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF8A00), Color(0xFFFF4D00)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF4D00).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Hexagon-like shape hint
          CustomPaint(
            size: const Size(56, 56),
            painter: _HexBadgePainter(),
          ),
          // Badge text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, color: Colors.white, size: 14),
              const SizedBox(height: 2),
              Text(
                badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(Map<String, dynamic> filter) {
    bool isSelected = _selectedFilter == filter['name'];
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = filter['name']),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : const Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? Colors.white : Colors.white24,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                filter['icon'],
                size: 18,
                color: isSelected ? Colors.black : Colors.white70,
              ),
              const SizedBox(width: 6),
              Text(
                filter['name'],
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events_outlined, color: Colors.white24, size: 80),
          const SizedBox(height: 16),
          const Text(
            'No active challenges yet',
            style: TextStyle(color: Colors.white54, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            'Join a challenge to get started!',
            style: TextStyle(color: Colors.white38, fontSize: 14),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => setState(() => _selectedTabIndex = 1),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF4D00),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            child: const Text('Browse Challenges', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildClubsContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.groups_outlined, color: Colors.white24, size: 80),
          const SizedBox(height: 16),
          const Text(
            'Clubs coming soon',
            style: TextStyle(color: Colors.white54, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            'Join clubs to connect with others!',
            style: TextStyle(color: Colors.white38, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(Icons.home_outlined, 'Home', false),
              _buildBottomNavItem(Icons.terrain, 'Maps', false),
              _buildBottomNavItem(Icons.radio_button_checked, 'Record', false),
              _buildBottomNavItem(Icons.diamond_outlined, 'Groups', true),
              _buildBottomNavItem(Icons.grid_view_rounded, 'You', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (label == 'Home') {
          Navigator.pop(context);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFFFF4D00) : Colors.white38,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFFF4D00) : Colors.white38,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showJoinedSnackbar(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Joined: $title'),
        backgroundColor: const Color(0xFFFF4D00),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _HexBadgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final path = Path();
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.4;

    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 30) * math.pi / 180;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
