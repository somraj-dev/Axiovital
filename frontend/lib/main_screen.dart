import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_page.dart';
import 'vitalsync_dashboard.dart';
import 'find_doctor_page.dart';
import 'health_insights_page.dart';
import 'user_provider.dart';
import 'permission_service.dart';
import 'lab_tests_page.dart';
import 'widgets/axio_avatar.dart';
import 'theme_provider.dart';
import 'orders_page.dart';
import 'partner_hospitals_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _inSubNav = false;
  int _subSelectedIndex = 1;

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

  final List<Widget> _subPages = [
    const SizedBox.shrink(),
    const FindDoctorPage(key: ValueKey('FindDoctorSub')),
    const PartnerHospitalsPage(key: ValueKey('PartnerHospitalsSub')),
    const Scaffold(body: Center(child: Text('Clinic Coming Soon', style: TextStyle(fontSize: 20)))),
    const OrdersPage(key: ValueKey('OrdersSub')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        _inSubNav = true;
        _subSelectedIndex = 1;
      } else {
        _inSubNav = false;
      }
    });
  }

  void _onSubItemTapped(int index) {
    if (index == 0) {
      setState(() {
        _inSubNav = false;
        _selectedIndex = 0;
      });
    } else {
      setState(() {
        _subSelectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isTransparent = themeProvider.isBottomBarTransparent;
    final showSubNav = _selectedIndex == 1 || _inSubNav;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBody: isTransparent,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: showSubNav ? _subPages[_subSelectedIndex] : _pages[_selectedIndex],
          ),
          if (isTransparent && !showSubNav)
            Positioned(
              left: 24,
              right: 24,
              bottom: 30,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: _buildNavBar(isTransparent: true),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: showSubNav 
          ? _buildSubNavBar() 
          : (isTransparent ? null : _buildNavBar(isTransparent: false)),
    );
  }

  Widget _buildNavBar({required bool isTransparent}) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: isTransparent 
            ? Colors.black.withOpacity(0.4) 
            : theme.colorScheme.surface,
        border: Border(
          top: isTransparent 
              ? BorderSide.none 
              : BorderSide(color: theme.dividerColor, width: 0.5),
        ),
        boxShadow: isTransparent ? [] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0, 
            vertical: isTransparent ? 12.0 : 8.0
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                icon: _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                label: userProvider.translate('home'),
                isSelected: _selectedIndex == 0,
                onTap: () => _onItemTapped(0),
              ),
              _buildNavItem(
                icon: _selectedIndex == 1 ? Icons.medical_services : Icons.medical_services_outlined,
                label: userProvider.translate('doctors'),
                isSelected: _selectedIndex == 1,
                onTap: () => _onItemTapped(1),
              ),
              _buildNavItem(
                icon: _selectedIndex == 2 ? Icons.science : Icons.science_outlined,
                label: userProvider.translate('labs'),
                isSelected: _selectedIndex == 2,
                onTap: () => _onItemTapped(2),
              ),
              _buildNavItem(
                icon: _selectedIndex == 3 ? Icons.insights : Icons.insights_outlined,
                label: userProvider.translate('insights'),
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
                      userProvider.translate('profile'),
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

  Widget _buildSubNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSubNavItem(
                iconWidget: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: const Icon(Icons.arrow_back, size: 16, color: Colors.black),
                ),
                label: 'Home',
                isSelected: false,
                onTap: () => _onSubItemTapped(0),
              ),
              _buildSubNavItem(
                iconWidget: Icon(
                  Icons.medical_services,
                  size: 24,
                  color: _subSelectedIndex == 1 ? Colors.black : Colors.black87,
                ),
                label: 'Doctor',
                isSelected: _subSelectedIndex == 1,
                onTap: () => _onSubItemTapped(1),
              ),
              _buildSubNavItem(
                iconWidget: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.local_hospital,
                      size: 24,
                      color: _subSelectedIndex == 2 ? Colors.black : Colors.black87,
                    ),
                    Positioned(
                      top: -6,
                      right: -12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5247),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'NEW',
                          style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                label: 'Hospitals',
                isSelected: _subSelectedIndex == 2,
                onTap: () => _onSubItemTapped(2),
              ),
              _buildSubNavItem(
                iconWidget: Icon(
                  Icons.healing,
                  size: 24,
                  color: _subSelectedIndex == 3 ? Colors.black : Colors.black87,
                ),
                label: 'Clinic',
                isSelected: _subSelectedIndex == 3,
                onTap: () => _onSubItemTapped(3),
              ),
              _buildSubNavItem(
                iconWidget: Icon(
                  Icons.receipt_long,
                  size: 24,
                  color: _subSelectedIndex == 4 ? Colors.black : Colors.black87,
                ),
                label: 'My Orders',
                isSelected: _subSelectedIndex == 4,
                onTap: () => _onSubItemTapped(4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubNavItem({
    required Widget iconWidget,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.black : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
