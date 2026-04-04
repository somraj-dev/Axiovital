import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'profile_page.dart';
import 'habit_tracker_page.dart';
import 'consultations_page.dart';
import 'test_bookings_page.dart';
import 'orders_page.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
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
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: NetworkImage(userProvider.avatarUrl),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              userProvider.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D2939),
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: Color(0xFF98A2B3)),
                          ],
                        ),
                        const SizedBox(height: 4),
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
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '9% completed',
                          style: TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Progress Bar
                        Container(
                          height: 4,
                          width: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F4F7),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.09,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E90FA),
                                borderRadius: BorderRadius.circular(2),
                              ),
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2D3282), // Dark blue from screenshot
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.favorite_border, color: Color(0xFFF9DC5C), size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Care Plan',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '12 FREE Appointments for a Year',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.white, size: 20),
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
                    'ABHA', 
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
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F9FF), // Very pale blue from high-fidelity image
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xFF344054),
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 18, color: Color(0xFFD0D5DD)),
      onTap: onTap ?? () {},
    );
  }
}
