import 'package:flutter/material.dart';

class FitLeaguePage extends StatefulWidget {
  const FitLeaguePage({super.key});

  @override
  State<FitLeaguePage> createState() => _FitLeaguePageState();
}

class _FitLeaguePageState extends State<FitLeaguePage> {
  String selectedTab = 'Challenges';
  String selectedFilter = 'Run';

  final List<String> tabs = ['Active', 'Challenges', 'Clubs'];
  final List<Map<String, dynamic>> filters = [
    {'name': 'Run', 'icon': Icons.directions_run},
    {'name': 'Ride', 'icon': Icons.directions_bike},
    {'name': 'Swim', 'icon': Icons.pool},
    {'name': 'Walk', 'icon': Icons.directions_walk},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Groups',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.chat_bubble_outline, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings_outlined, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: tabs.map((tab) => _buildTab(tab)).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Filter Chips
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  return _buildFilterChip(filters[index]);
                },
              ),
            ),
            const SizedBox(height: 24),

            // Featured Challenge Card (Strava | Brooks)
            _buildFeaturedChallenge(),

            const SizedBox(height: 24),

            // Recommended Section Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.person_pin_circle_outlined, color: Colors.white70, size: 20),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recommended For You',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
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

            // Recommended Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(child: _buildSmallChallengeCard('April 400-minute x Runna Challenge', 'Complete 400 mins of activity in April', 'Apr 1 to Apr 30, 2026', 'assets/images/400_min.png')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildSmallChallengeCard('HOKA Speedgoat 7 Vert Challenge', 'Log 7,000 feet of elevation gain', 'Apr 9 to May 8, 2026', 'assets/images/hoka.png')),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(child: _buildSmallChallengeCard('April 5K x AxioVital Challenge', 'Complete a 5 km run', 'Apr 1 to Apr 30, 2026', 'assets/images/axiovital_icon.png')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildSmallChallengeCard('April Ten Days Active Challenge', 'Do 10 minutes of activity for 10 days', 'Apr 1 to Apr 30, 2026', 'assets/images/ten_days.png')),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // More Challenges Section
            _buildChallengeListTile('April 180 Minute Sweat Challenge', 'Complete a single 180-min activity', 'Apr 1 to Apr 30, 2026'),
            _buildChallengeListTile('April Ride 200K Challenge', 'Bike a total of 200 km in April', 'Apr 1 to Apr 30, 2026'),
            _buildChallengeListTile('April Gran Fondo Challenge', 'Complete a 100 km ride', 'Apr 1 to Apr 30, 2026'),
            _buildChallengeListTile('April Elevation Challenge', 'Climb a total of 2,000 m in April', 'Apr 1 to Apr 30, 2026'),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String tab) {
    bool isSelected = selectedTab == tab;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = tab),
      child: Column(
        children: [
          Text(
            tab,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white54,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 3,
            width: 80,
            color: isSelected ? const Color(0xFFFF5722) : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(Map<String, dynamic> filter) {
    bool isSelected = selectedFilter == filter['name'];
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        avatar: Icon(filter['icon'], size: 18, color: isSelected ? Colors.black : Colors.white70),
        label: Text(filter['name']),
        labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
        backgroundColor: isSelected ? Colors.white : const Color(0xFF2C2C2E),
        onPressed: () => setState(() => selectedFilter = filter['name']),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isSelected ? Colors.white : Colors.white24)),
      ),
    );
  }

  Widget _buildFeaturedChallenge() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF8A00), Color(0xFFFF4D00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Stack(
                children: [
                  Center(
                    child: Text(
                      'AXIOVITAL | FITLEAGUE',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 28),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(color: const Color(0xFFFF4D00), borderRadius: BorderRadius.circular(8)),
                      child: const Center(child: Text('5K', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('April 5K x AxioVital Challenge', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                          SizedBox(height: 4),
                          Text('Complete a 5 km (3.1 mi) run.', style: TextStyle(color: Colors.white70, fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Apr 1 to Apr 30, 2026', style: TextStyle(color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF4D00),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('Join', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallChallengeCard(String title, String subtitle, String date, String imgPath) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.fitness_center, color: Color(0xFFFF4D00), size: 30),
          ),
          const SizedBox(height: 12),
          Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 4),
          Text(date, style: const TextStyle(color: Colors.white54, fontSize: 10)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4D00),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: const Text('Join', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeListTile(String title, String subtitle, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.timer_outlined, color: Colors.orange),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 8),
                Text(date, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                const SizedBox(height: 16),
                SizedBox(
                  width: 120,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF4D00),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Join', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
