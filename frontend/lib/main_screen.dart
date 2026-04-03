import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_page.dart';
import 'home_page.dart';
import 'find_doctor_page.dart';
import 'health_insights_page.dart';
import 'user_provider.dart';
import 'permission_service.dart';
import 'vitalsync_settings_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Proactively ask for notifications on app launch (Modern UX)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PermissionService().requestNotificationPermission(context);
    });
  }

  // Placeholder pages for each tab
  // Placeholder pages for each tab
  final List<Widget> _pages = [
    const HomePage(key: ValueKey('HomePage')), // Connected the newly created Home Page
    const FindDoctorPage(key: ValueKey('FindDoctor')), // Attached the Doctor Directory to the 2nd slot
    const Center(key: ValueKey('Messages'), child: Text('Messages', style: TextStyle(color: Colors.white, fontSize: 24))),
    const HealthInsightsPage(key: ValueKey('HealthInsights')), // Attached the new Health Insights Page
    const VitalsyncSettingsPage(key: ValueKey('SettingsPage')), // Replaced Profile with the comprehensive Settings Page
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background as shown in screenshot
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F0F0F), // Very dark grey, almost black
          border: Border(
            top: BorderSide(
              color: Color(0xFF202020), // Subtle separator line
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 1. Home Icon (Unfilled house)
                _buildNavItem(
                  icon: _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                  isSelected: _selectedIndex == 0,
                  onTap: () => _onItemTapped(0),
                ),
                
                // 2. Video/Reels (Rounded square with play button inside)
                _buildNavItem(
                  // We simulate the icon loosely via a play square
                  icon: _selectedIndex == 1 ? Icons.smart_display : Icons.smart_display_outlined,
                  isSelected: _selectedIndex == 1,
                  onTap: () => _onItemTapped(1),
                ),
                
                // 3. Threads/Messages icon with a red badge (Custom shape resembling the screenshot)
                _buildNavItemWithBadge(
                  icon: _selectedIndex == 2 ? Icons.send : Icons.send_outlined,
                  badgeText: '7',
                  isSelected: _selectedIndex == 2,
                  onTap: () => _onItemTapped(2),
                ),
                
                // 4. Search (Magnifying glass)
                _buildNavItem(
                  icon: Icons.search,
                  isSelected: _selectedIndex == 3,
                  onTap: () => _onItemTapped(3),
                  iconSize: 32, // Slightly larger as in screenshot
                ),
                
                // 5. Profile Picture (Circular Image)
                GestureDetector(
                  onTap: () => _onItemTapped(4),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedIndex == 4 ? Colors.white : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(Provider.of<UserProvider>(context).avatarUrl),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    double iconSize = 28,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Icon(
          icon,
          size: iconSize,
          color: isSelected ? Colors.white : Colors.white70,
        ),
      ),
    );
  }

  Widget _buildNavItemWithBadge({
    required IconData icon,
    required String badgeText,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Icon(
              icon,
              size: 28,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
          Positioned(
            right: 2,
            bottom: 4, // Badge placed bottom right like the screenshot
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFFE73541), // Vibrant red from screenshot
                shape: BoxShape.circle,
              ),
              child: Text(
                badgeText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
