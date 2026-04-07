import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'profile_page.dart';
import 'habit_tracker_page.dart';
import 'consultations_page.dart';
import 'test_bookings_page.dart';
import 'orders_page.dart';
import 'help_center_page.dart';
import 'read_about_health_page.dart';
import 'health_passport_page.dart';
import 'emergency_card_page.dart';
import 'widgets/axio_avatar.dart';
import 'widgets/axio_card.dart';
import 'theme.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      backgroundColor: theme.scaffoldBackgroundColor,
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
                    radius: 32,
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
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                          child: Text(
                            'View and edit profile',
                            style: TextStyle(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
              child: AxioCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.stars_rounded, color: theme.primaryColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Care Plan',
                            style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '12 FREE Appointments',
                            style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.3), size: 18),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Navigation List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerItem(
                    context,
                    Icons.add_box_outlined, 
                    'Habit Tracker', 
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HabitTrackerPage()),
                      );
                    },
                  ),
                  _buildDrawerItem(context, Icons.calendar_month_outlined, 'Appointments'),
                  _buildDrawerItem(
                    context,
                    Icons.science_outlined, 
                    'Test Bookings', 
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TestBookingsPage()));
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.local_pharmacy_outlined, 
                    'Orders', 
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const OrdersPage()));
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.chat_bubble_outline, 
                    'Consultations', 
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ConsultationsPage()));
                    },
                  ),
                  _buildDrawerItem(context, Icons.person_pin_outlined, 'My Doctors'),
                  
                  // Medical Specific section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                    child: Text('MEDICAL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface.withOpacity(0.4), letterSpacing: 1.2)),
                  ),
                  
                  _buildDrawerItem(
                    context,
                    Icons.admin_panel_settings_outlined, 
                    'Health Passport', 
                    iconColor: theme.primaryColor,
                    textColor: theme.primaryColor,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HealthPassportPage()));
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.contact_emergency_outlined, 
                    'Emergency Card', 
                    iconColor: theme.primaryColor,
                    textColor: theme.primaryColor,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const EmergencyCardPage()));
                    },
                  ),
                  _buildDrawerItem(context, Icons.verified_user_outlined, 'My Insurance Policy'),
                  
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                    child: Text('GENERAL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface.withOpacity(0.4), letterSpacing: 1.2)),
                  ),

                  _buildDrawerItem(context, Icons.notifications_active_outlined, 'Reminders'),
                  _buildDrawerItem(context, Icons.account_balance_wallet_outlined, 'Payments & HealthCash'),
                  _buildDrawerItem(
                    context,
                    Icons.settings_outlined, 
                    'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfilePage()),
                      );
                    },
                  ),
                  _buildDrawerItem(context, Icons.help_outline, 'Help Center'),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, {Color? iconColor, Color? textColor, VoidCallback? onTap}) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      dense: true,
      leading: Icon(icon, color: iconColor ?? theme.colorScheme.onSurface.withOpacity(0.6), size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textColor ?? theme.colorScheme.onSurface,
        ),
      ),
      onTap: onTap ?? () {},
    );
  }
}
