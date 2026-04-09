import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_page.dart';
import 'home_page.dart';
import 'vitalsync_dashboard.dart';
import 'find_doctor_page.dart';
import 'health_insights_page.dart';
import 'user_provider.dart';
import 'permission_service.dart';
import 'lab_tests_page.dart';
import 'widgets/axio_avatar.dart';
import 'theme.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PermissionService().requestNotificationPermission(context);
    });
  }

  final List<Widget> _pages = [
    const VitalSyncDashboard(key: ValueKey('HomePage')),
    const FindDoctorPage(key: ValueKey('FindDoctor')),
    const LabTestsPage(key: ValueKey('LabTests')),
    const HealthInsightsPage(key: ValueKey('HealthInsights')),
    const ProfilePage(key: ValueKey('ProfilePage')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: theme.dividerColor,
              width: 0.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(
                  icon: _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                  label: 'Home',
                  isSelected: _selectedIndex == 0,
                  onTap: () => _onItemTapped(0),
                ),
                _buildNavItem(
                  icon: _selectedIndex == 1 ? Icons.medical_services : Icons.medical_services_outlined,
                  label: 'Doctors',
                  isSelected: _selectedIndex == 1,
                  onTap: () => _onItemTapped(1),
                ),
                _buildNavItem(
                  icon: _selectedIndex == 2 ? Icons.science : Icons.science_outlined,
                  label: 'Lab Tests',
                  isSelected: _selectedIndex == 2,
                  onTap: () => _onItemTapped(2),
                ),
                _buildNavItem(
                  icon: _selectedIndex == 3 ? Icons.insights : Icons.insights_outlined,
                  label: 'Insights',
                  isSelected: _selectedIndex == 3,
                  onTap: () => _onItemTapped(3),
                ),
                GestureDetector(
                  onTap: () => _onItemTapped(4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _selectedIndex == 4 ? theme.primaryColor : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: AxioAvatar(
                          radius: 12,
                          imageUrl: userProvider.avatarUrl,
                          name: userProvider.name,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: _selectedIndex == 4 ? FontWeight.bold : FontWeight.normal,
                          color: _selectedIndex == 4 ? theme.primaryColor : theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
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
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected ? theme.primaryColor : theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? theme.primaryColor : theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
