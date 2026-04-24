import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'theme_provider.dart';
import 'widgets/axio_avatar.dart';
import 'widgets/axio_card.dart';
import 'update_profile_page.dart';
import 'user_clubs_page.dart';
import 'health_feed_provider.dart';
import 'read_about_health_page.dart'; // Assuming PostDetailScreen might be here or similar
import 'choose_address_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, theme, isDark, userProvider),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildHeaderInfo(theme, userProvider),
                  const SizedBox(height: 16),
                  _buildBio(theme),
                  const SizedBox(height: 20),
                  _buildMetaInfo(theme),
                  const SizedBox(height: 24),
                  _buildStatsRow(context, theme, isDark, userProvider),
                  const SizedBox(height: 32),
                  
                  // Keep Address management as it was useful
                  _buildSectionHeader('SAVED ADDRESSES', theme: theme),
                  const SizedBox(height: 12),
                  AxioCard(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChooseAddressPage()),
                        );
                      },
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: theme.primaryColor.withOpacity(0.1), shape: BoxShape.circle),
                        child: Icon(Icons.location_on_outlined, color: theme.primaryColor, size: 20),
                      ),
                      title: Text('Manage Delivery Addresses', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Home, Office, and other locations', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5), fontSize: 12)),
                      trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withOpacity(0.3)),
                    ),
                  ),
                  const SizedBox(height: 32),

                  _buildActivitySection(context, theme, isDark, userProvider),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, ThemeData theme, bool isDark, UserProvider user) {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.3),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      actions: [
        _buildCircleIconButton(Icons.ios_share, () {}),
        const SizedBox(width: 8),
        _buildCircleIconButton(Icons.settings, () {
          Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
        }),
        const SizedBox(width: 8),
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateProfilePage()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.8),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Edit profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
        const SizedBox(width: 16),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Wave Background
            ClipPath(
              clipper: _HeaderClipper(),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2C1A1A), Color(0xFF632B3B), Color(0xFF903050)],
                  ),
                ),
                child: Opacity(
                  opacity: 0.1,
                  child: Image.network(
                    'https://images.unsplash.com/photo-1550684848-fac1c5b4e853?q=80&w=2070&auto=format&fit=crop',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            // Avatar Positioned
            Positioned(
              bottom: 0,
              left: 20,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  children: [
                    AxioAvatar(
                      radius: 40,
                      imageUrl: user.avatarUrl,
                      name: user.name,
                    ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1DB954),
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.scaffoldBackgroundColor, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(ThemeData theme, UserProvider user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              user.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.verified, color: Colors.orange, size: 20),
          ],
        ),
        Text(
          user.axioId,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildBio(ThemeData theme) {
    return const Text(
      'Healthy lifestyle enthusiast & Clinical Researcher. Dedicated to personal wellness and helping others achieve their health goals. 🩺✨',
      style: TextStyle(fontSize: 15, height: 1.4),
    );
  }

  Widget _buildMetaInfo(ThemeData theme) {
    const opacity = 0.5;
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.location_on_outlined, size: 16, color: theme.colorScheme.onSurface.withOpacity(opacity)),
            const SizedBox(width: 4),
            Text('Mumbai, India', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(opacity), fontSize: 13)),
            const SizedBox(width: 16),
            Icon(Icons.calendar_today_outlined, size: 16, color: theme.colorScheme.onSurface.withOpacity(opacity)),
            const SizedBox(width: 4),
            Text('Joined Jan 2024', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(opacity), fontSize: 13)),
            const SizedBox(width: 16),
            Icon(Icons.link, size: 16, color: theme.primaryColor),
            const SizedBox(width: 4),
            Text('Links', style: TextStyle(color: theme.primaryColor, fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context, ThemeData theme, bool isDark, UserProvider user) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('1 Club owned', theme, isDark, onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserClubsPage(title: 'Clubs owned', userName: user.name)));
          }),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('12 Clubs joined', theme, isDark, onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => UserClubsPage(title: 'Clubs joined', userName: user.name)));
          }),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, ThemeData theme, bool isDark, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.02),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required ThemeData theme}) {
    return Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface.withOpacity(0.4), fontSize: 12, letterSpacing: 0.5),
    );
  }

  Widget _buildActivitySection(BuildContext context, ThemeData theme, bool isDark, UserProvider user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text('Sort', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.6))),
                  const Icon(Icons.arrow_drop_down, size: 16),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildActivityItem(
          context: context,
          theme: theme,
          isDark: isDark,
          user: user,
          title: 'My Recovery Journey',
          subtitle: 'Starting to feel much better after the recent therapy sessions.',
          time: '1h',
          views: '245',
          image: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=2020&auto=format&fit=crop',
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required BuildContext context,
    required ThemeData theme,
    required bool isDark,
    required UserProvider user,
    required String title,
    required String subtitle,
    required String time,
    required String views,
    required String image,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigation to details (using first post ID for demo or a unique one)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (_) => HealthFeedProvider(),
              child: const PostDetailScreen(postId: 'hp_1'),
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AxioAvatar(radius: 12, imageUrl: user.avatarUrl, name: user.name),
              const SizedBox(width: 8),
              Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const Spacer(),
              Icon(Icons.visibility_outlined, size: 14, color: theme.colorScheme.onSurface.withOpacity(0.4)),
              const SizedBox(width: 4),
              Text(views, style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withOpacity(0.4))),
              const SizedBox(width: 12),
              Icon(Icons.access_time, size: 14, color: theme.colorScheme.onSurface.withOpacity(0.4)),
              const SizedBox(width: 4),
              Text(time, style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withOpacity(0.4))),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6), fontSize: 13)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              image,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    
    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    
    final secondControlPoint = Offset(size.width * 3/4, size.height - 60);
    final secondEndPoint = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
