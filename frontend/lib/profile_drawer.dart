import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'profile_page.dart';
import 'habit_tracker_page.dart';
import 'consultations_page.dart';
import 'test_bookings_page.dart';
import 'orders_page.dart';
import 'widgets/axio_avatar.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.72,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AxioAvatar(
                    radius: 36,
                    imageUrl: userProvider.avatarUrl,
                    name: userProvider.name,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userProvider.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D2939),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context); // Close drawer
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ProfilePage()),
                            );
                          },
                          child: const Text(
                            'View and edit profile',
                            style: TextStyle(
                              color: Color(0xFF2E90FA),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Care Plan Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1D2939), // Minimal Slate/Black
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.stars_rounded, color: Color(0xFFF9DC5C), size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Care Plan',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            '12 FREE Appointments',
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.white70, size: 16),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Navigation List
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    Icons.add_box, 
                    'Habit Tracker', 
                    const Color(0xFF2E90FA),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HabitTrackerPage()),
                      );
                    },
                  ),
                  _buildDrawerItem(Icons.calendar_month, 'Appointments', const Color(0xFF2E90FA)),
                  _buildDrawerItem(
                    Icons.science_outlined, 
                    'Test Bookings', 
                    const Color(0xFF2E90FA),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TestBookingsPage()));
                    },
                  ),
                  _buildDrawerItem(
                    Icons.local_pharmacy_outlined, 
                    'Orders', 
                    const Color(0xFF2E90FA),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const OrdersPage()));
                    },
                  ),
                  _buildDrawerItem(
                    Icons.chat_bubble_outline, 
                    'Consultations', 
                    const Color(0xFF2E90FA),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ConsultationsPage()));
                    },
                  ),
                  _buildDrawerItem(Icons.person_pin_outlined, 'My Doctors', const Color(0xFF2E90FA)),
                  _buildDrawerItem(Icons.assignment_outlined, 'Medical Records', const Color(0xFF2E90FA)),
                  _buildDrawerItem(Icons.verified_user_outlined, 'My Insurance Policy', const Color(0xFF2E90FA)),
                  _buildDrawerItem(Icons.notifications_active_outlined, 'Reminders', const Color(0xFF2E90FA)),
                  _buildDrawerItem(Icons.account_balance_wallet_outlined, 'Payments & HealthCash', const Color(0xFF2E90FA)),
                  _buildDrawerItem(Icons.apple_outlined, 'Read about health', const Color(0xFF2E90FA)),
                  _buildDrawerItem(Icons.help_outline, 'Help Center', const Color(0xFF2E90FA)),
                  _buildDrawerItem(Icons.settings_outlined, 'Settings', const Color(0xFF2E90FA)),
                  _buildDrawerItem(Icons.thumb_up_outlined, 'Like us? Give us 5 stars', const Color(0xFF2E90FA)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, Color iconColor, {VoidCallback? onTap}) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: const Color(0xFF475569), size: 22), // No bulky background
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF344054),
        ),
      ),
      onTap: onTap ?? () {},
    );
  }
}
