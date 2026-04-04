import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'profile_page.dart';

class HabitTrackerPage extends StatelessWidget {
  const HabitTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar
              _buildTopBar(context),
              const SizedBox(height: 24),

              // Search Bar
              _buildSearchBar(),
              const SizedBox(height: 32),

              // Header: Your Habit (18)
              _buildHabitHeader(),
              const SizedBox(height: 16),

              // Habit Card: Walk
              _buildHabitCard(
                icon: Icons.directions_run,
                title: 'Walk',
                goal: '4.000 steps | 3 days a week',
                stats: [
                  {'label': '4 days', 'value': 'Finished'},
                  {'label': '15%', 'value': 'Completed'},
                  {'label': '450', 'value': 'Steps'},
                ],
                showHeatmap: true,
              ),
              const SizedBox(height: 24),

              // Habit Card: Working Time
              _buildHabitCard(
                icon: Icons.laptop,
                title: 'Working Time',
                goal: '240 hours | 5 days a week',
                stats: [
                  {'label': '2 days', 'value': 'Finished'},
                  {'label': '15%', 'value': 'Completed'},
                  {'label': '84', 'value': 'hours'},
                ],
                showHeatmap: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(Provider.of<UserProvider>(context).avatarUrl),
            ),
            const SizedBox(width: 12),
            const Text(
              'Today, 18 Nov',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        Row(
          children: [
            _buildRoundIcon(Icons.calendar_today_outlined),
            const SizedBox(width: 12),
            _buildRoundIcon(
              Icons.settings_rounded,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              ),
            ),
            const SizedBox(width: 12),
            _buildRoundIcon(Icons.share_rounded),
          ],
        ),
      ],
    );
  }

  Widget _buildRoundIcon(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF262626), // Lighter grey for better visibility
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: const [
          Icon(Icons.search, color: Colors.white54, size: 24),
          SizedBox(width: 12),
          Text('Search Habit', style: TextStyle(color: Colors.white54, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildHabitHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Your Habit (18)',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFD60A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: const [
              Text('View All', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)),
              SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 18),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHabitCard({
    required IconData icon,
    required String title,
    required String goal,
    required List<Map<String, String>> stats,
    required bool showHeatmap,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: Color(0xFF262626), shape: BoxShape.circle),
                child: Icon(icon, color: Colors.white70, size: 20),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 4),
                  Text('Goal : $goal', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: stats.map((stat) => Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF262626),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(stat['label']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(stat['value']!, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                  ],
                ),
              ),
            )).toList(),
          ),
          if (showHeatmap) ...[
            const SizedBox(height: 24),
            _buildHeatmap(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(Icons.check_circle, 'Done', true),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(Icons.note_alt, 'Add Note', false),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF262626),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.image_outlined, color: Colors.white70, size: 24),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeatmap() {
    // Weekday labels
    final List<String> days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    // Mock data for completed days
    final List<int> completedIndices = [10, 18, 19, 32, 33, 34, 45, 46, 52, 53, 54, 60];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: days.map((day) => Container(
            height: 18,
            alignment: Alignment.center,
            child: Text(day, style: const TextStyle(color: Colors.white38, fontSize: 10)),
          )).toList(),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 14, // Roughly matches the screenshot
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: 14 * 7,
            itemBuilder: (context, index) {
              final isCompleted = completedIndices.contains(index);
              return Container(
                decoration: BoxDecoration(
                  color: isCompleted ? const Color(0xFFFFD60A) : const Color(0xFF1F1F1F),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: isCompleted ? [
                    BoxShadow(
                      color: const Color(0xFFFFD60A).withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 1,
                    )
                  ] : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, bool isPrimary) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFFFFD60A) : const Color(0xFF262626),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isPrimary ? Colors.black : Colors.white70, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isPrimary ? Colors.black : Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }


}
