import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'vitalsync_dashboard.dart';
import 'profile_drawer.dart';
import 'profile_page.dart';
import 'user_provider.dart';
import 'bluetooth_provider.dart';
import 'location_provider.dart';
import 'search_page.dart';
import 'health_passport_page.dart';
import 'lab_tests_page.dart';
import 'find_doctor_page.dart';
import 'widgets/axio_avatar.dart';
import 'widgets/axio_card.dart';
import 'widgets/axio_button.dart';
import 'theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const ProfileDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: Location & Cart
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: AppTheme.primaryColor),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Gwalior',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.onSurface),
                            ),
                            Icon(Icons.keyboard_arrow_down, size: 20, color: theme.colorScheme.onSurface),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant,
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(Icons.shopping_bag_outlined, color: theme.colorScheme.onSurface),
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(color: AppTheme.primaryColor, shape: BoxShape.circle),
                              child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage()));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: theme.colorScheme.outline.withOpacity(0.5)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Search for 'lab tests and packages'",
                          style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5), fontSize: 14),
                        ),
                        const Spacer(),
                        Icon(Icons.search, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                      ],
                    ),
                  ),
                ),
              ),

              // Category Horizontal List
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildCategory('Pharmacy', Icons.local_pharmacy, 'assets/pharmacy.png'),
                    _buildCategory('Lab tests', Icons.biotech, 'assets/lab.png', onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LabTestsPage()));
                    }),
                    _buildCategory('Generics', Icons.science, 'assets/generics.png', isNew: true),
                    _buildCategory('Pet Care', Icons.pets, 'assets/pets.png', isNew: true),
                    _buildCategory('Consult', Icons.chat, 'assets/consult.png', onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const FindDoctorPage()));
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Order with Prescription
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AxioCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                   showShadow: false,
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                  child: Row(
                    children: [
                      Icon(Icons.assignment_outlined, color: theme.primaryColor, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Order with prescription',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: theme.colorScheme.onSurface),
                        ),
                      ),
                      AxioButton(
                        text: 'Order now',
                        height: 35,
                        borderRadius: 20,
                        fontSize: 12,
                        onPressed: () {},
                        color: const Color(0xFF1F1F1F),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Promo Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome offer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: theme.colorScheme.onSurface.withOpacity(0.6))),
                          const SizedBox(height: 4),
                          const Text(
                            '10% extra off',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 13),
                              children: [
                                const TextSpan(text: 'on first order | Use code '),
                                TextSpan(
                                  text: '1MGNEW',
                                  style: TextStyle(backgroundColor: AppTheme.successColor.withOpacity(0.1), color: AppTheme.successColor, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Large Savings Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AxioCard(
                  padding: EdgeInsets.zero,
                  showShadow: false,
                  borderSide: BorderSide.none,
                  color: const Color(0xFFFFF7EF),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Up to\n50% Savings',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: theme.colorScheme.onSurface),
                              ),
                              const SizedBox(height: 8),
                              const Text('with Generic Medicines', style: TextStyle(fontSize: 16)),
                              const SizedBox(height: 20),
                              AxioButton(
                                text: 'Explore Generics Now',
                                height: 40,
                                borderRadius: 4,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Generics catalogue coming soon!'), behavior: SnackBarBehavior.floating));
                                },
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Placeholder for banner image (could use decorative icon or circle)
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Free Delivery Progress Bar (Floating style)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFF903050), // Maroon color from screenshot
                ),
                child: Column(
                  children: [
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Colors.white, fontSize: 13),
                        children: [
                          TextSpan(text: 'Add items worth '),
                          TextSpan(text: '₹207', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ' to unlock '),
                          TextSpan(text: 'Free Delivery', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 4,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(2)),
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 4,
                        width: 120, // 40% filled
                        decoration: BoxDecoration(color: AppTheme.successColor, borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
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

  Widget _buildCategory(String title, IconData icon, String assetPath, {bool isNew = false, VoidCallback? onTap}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AxioCard(
                  padding: const EdgeInsets.all(12),
                  showShadow: false,
                   color: theme.colorScheme.surface,
                  child: Icon(icon, color: AppTheme.primaryColor, size: 30),
                ),
              if (isNew)
                Positioned(
                  top: -5,
                  right: -5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(8)),
                    child: const Text('NEW', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: theme.colorScheme.onSurface)),
          ],
        ),
      ),
    );
  }
}
