import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'health_passport_page.dart';
import 'cart_provider.dart';
import 'cart_page.dart';

class AxioCardPage extends StatefulWidget {
  const AxioCardPage({super.key});

  @override
  State<AxioCardPage> createState() => _AxioCardPageState();
}

class _AxioCardPageState extends State<AxioCardPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1113) : const Color(0xFFF8F9FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- MAIN AXIO CARD ---
              _buildPremiumAxioCard(user, isDark),
              const SizedBox(height: 32),

              // --- FEATURE ICONS WITH DIVIDERS ---
              _buildDividedFeatures(isDark),
              const SizedBox(height: 24),

              // --- VIEW HEALTH PROFILE CTA ---
              _buildHealthProfileCTA(context),
              const SizedBox(height: 16),

              // --- RECENT ACTIVITY TOGGLE ---
              _buildActivityToggle(isDark),
              const SizedBox(height: 40),

              // --- DO MORE SECTION ---
              _buildDoMoreSection(isDark),
              const SizedBox(height: 32),

              // --- BOTTOM STATUS BAR ---
              _buildBottomStatus(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumAxioCard(UserProvider user, bool isDark) {
    final rawId = user.axioId.replaceAll('-', '');
    final formattedId = 'AXV0 ${rawId.substring(0, 4)} ${rawId.length > 4 ? rawId.substring(4, 8) : '9231'}';

    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF111111),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Left Gold Strip
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 12,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFC5A059), Color(0xFFD4AF37), Color(0xFFB8860B)],
                ),
              ),
            ),
          ),
          
          // Card Content
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 24, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'AxioVital',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'HEALTH SYSTEM',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Chip icon
                        Container(
                          width: 38,
                          height: 28,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE5C76B), Color(0xFFD4AF37)],
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(3, (index) => Container(
                                width: 24,
                                height: 1.5,
                                margin: const EdgeInsets.symmetric(vertical: 1.5),
                                color: Colors.black26,
                              )),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.wifi_tethering, color: Colors.white.withOpacity(0.8), size: 24),
                      ],
                    ),
                  ],
                ),
                
                const Spacer(),
                
                // Interlocking Logo in Center
                Center(
                  child: CustomPaint(
                    size: const Size(80, 50),
                    painter: InterlockingSwooshPainter(),
                  ),
                ),
                
                const Spacer(),
                
                // Bottom Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AXIO-ID',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedId,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Active',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4ADE80),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'NFC Enabled',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDividedFeatures(bool isDark) {
    final bgColor = isDark ? const Color(0xFF1A1C1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? Colors.white54 : Colors.black54;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(child: _featureItem(Icons.wifi_tethering, 'Tap to Access', 'Hospital Services', textColor, subColor)),
            VerticalDivider(width: 1, thickness: 1, color: Colors.black.withOpacity(0.05), indent: 20, endIndent: 20),
            Expanded(child: _featureItem(Icons.person_outline, 'One-Tap', 'Check-In', textColor, subColor)),
            VerticalDivider(width: 1, thickness: 1, color: Colors.black.withOpacity(0.05), indent: 20, endIndent: 20),
            Expanded(child: _featureItem(Icons.description_outlined, 'Instant', 'Appointment Slip', textColor, subColor)),
          ],
        ),
      ),
    );
  }

  Widget _featureItem(IconData icon, String title, String subtitle, Color textColor, Color subColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF6366F1), size: 28),
          const SizedBox(height: 12),
          Text(title, style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, textAlign: TextAlign.center, style: TextStyle(color: subColor, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildHealthProfileCTA(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        cartProvider.addItem(
          productId: 'axio_card_001',
          name: 'Axio-Card (Premium)',
          price: 999.0,
          imagePath: 'https://images.unsplash.com/photo-1550565118-3d1432d238e0?q=80&w=2070&auto=format&fit=crop', // A better black card representation
          type: CartItemType.subscription,
          subtitle: 'One Axio-ID = One Axio-Card',
          fulfilledBy: 'AxioVital Team',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Axio-Card added to cart!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF6366F1),
            action: SnackBarAction(
              label: 'VIEW CART',
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()));
              },
            ),
          ),
        );

        Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shield_outlined, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                const Text(
                  'Order Your Card',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const Positioned(
              right: 20,
              child: Icon(Icons.chevron_right, color: Colors.white70, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityToggle(bool isDark) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? Colors.white10 : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.loop, size: 18, color: Colors.black54),
            const SizedBox(width: 8),
            const Text(
              'switch to recent activity',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoMoreSection(bool isDark) {
    final titleColor = isDark ? Colors.white60 : Colors.black54;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'DO MORE WITH AXIOVITAL',
              style: TextStyle(
                color: titleColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('03', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _doMoreCard(
                'FAST TRACK CHECK-IN',
                'Skip hospital queues',
                'Tap your AxioCard at the kiosk and get your appointment slip instantly.',
                'https://images.unsplash.com/photo-1516549655169-df83a0774514?q=80&w=2070&auto=format&fit=crop',
                Icons.directions_run,
                isDark,
              ),
              const SizedBox(width: 16),
              _doMoreCard(
                'SMART RECEPTION',
                'Instant registration',
                'Tap your card at the reception for instant patient identification.',
                'https://images.unsplash.com/photo-1532938911079-1b06ac7ceec7?q=80&w=2089&auto=format&fit=crop',
                Icons.person_search,
                isDark,
              ),
              const SizedBox(width: 16),
              _doMoreCard(
                'PRIORITY ACCESS',
                'Dedicated healthcare lane',
                'Enjoy priority access with AxioVital fast-track lanes at partner hospitals.',
                'https://images.unsplash.com/photo-1551076805-e1869033e561?q=80&w=2070&auto=format&fit=crop',
                Icons.access_time,
                isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _doMoreCard(String title, String sub, String desc, String img, IconData badgeIcon, bool isDark) {
    final cardBg = isDark ? const Color(0xFF1A1C1E) : Colors.white;
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(img, height: 120, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: Icon(badgeIcon, size: 14, color: const Color(0xFF6366F1)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                const SizedBox(height: 4),
                Text(sub, style: const TextStyle(fontSize: 11, color: Color(0xFF6366F1), fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(desc, style: TextStyle(fontSize: 10, color: Colors.black54, height: 1.4), maxLines: 3),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Explore', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigoAccent)),
                    Icon(Icons.chevron_right, size: 16, color: Colors.indigoAccent),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomStatus(bool isDark) {
    final cardBg = isDark ? const Color(0xFF1A1C1E) : Colors.white;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFEEF2FF), shape: BoxShape.circle),
            child: Icon(Icons.verified_user, color: const Color(0xFF6366F1), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your AxioCard is active and ready to use',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  'Use it at any partner hospital to access fast & seamless care.',
                  style: TextStyle(color: Colors.black54, fontSize: 11),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.black26),
        ],
      ),
    );
  }
}

class InterlockingSwooshPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    final path1 = Path();
    path1.moveTo(size.width * 0.4, size.height * 0.2);
    path1.quadraticBezierTo(size.width * 0.7, size.height * 0.1, size.width * 0.8, size.height * 0.5);
    path1.quadraticBezierTo(size.width * 0.9, size.height * 0.9, size.width * 0.5, size.height * 0.8);
    path1.quadraticBezierTo(size.width * 0.3, size.height * 0.7, size.width * 0.4, size.height * 0.2);
    canvas.drawPath(path1, paint);

    final path2 = Path();
    path2.moveTo(size.width * 0.6, size.height * 0.8);
    path2.quadraticBezierTo(size.width * 0.3, size.height * 0.9, size.width * 0.2, size.height * 0.5);
    path2.quadraticBezierTo(size.width * 0.1, size.height * 0.1, size.width * 0.5, size.height * 0.2);
    path2.quadraticBezierTo(size.width * 0.7, size.height * 0.3, size.width * 0.6, size.height * 0.8);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
