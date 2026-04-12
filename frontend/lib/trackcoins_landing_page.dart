import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'trackcoins_provider.dart';
import 'trackcoins_page.dart';
import 'care_plan_page.dart';

class TrackcoinsLandingPage extends StatefulWidget {
  const TrackcoinsLandingPage({super.key});

  @override
  State<TrackcoinsLandingPage> createState() => _TrackcoinsLandingPageState();
}

class _TrackcoinsLandingPageState extends State<TrackcoinsLandingPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrackcoinsProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Image.network(
              'https://cdn-icons-png.flaticon.com/512/2862/2862899.png',
              width: 24,
              height: 24,
              color: const Color(0xFFE11D48),
            ),
            const SizedBox(width: 8),
            const Text(
              'AxioVital',
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HERO SECTION: STATIC FALLING COINS & BALANCE
            SizedBox(
              height: 280,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Static arch of background coins with motion trails
                  ..._buildStaticFallingCoins(),
                  
                  // Balance Text
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 70),
                      const Text(
                        'My Balance',
                        style: TextStyle(color: Color(0xFF1D2939), fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${provider.availableBalance}.0',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // ACTION CARDS ROW
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Card 1: Trackcoins Balance (Navigates to TrackcoinsPage)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TrackcoinsPage()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFEAECF0)),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(Icons.toll_rounded, color: Color(0xFFF59E0B), size: 18),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${provider.availableBalance}.0',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Total Trackcoins Balance',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF667085), height: 1.2),
                            ),
                            const SizedBox(height: 16),
                            const Row(
                              children: [
                                Text(
                                  'View History',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFE11D48)),
                                ),
                                Icon(Icons.chevron_right_rounded, color: Color(0xFFE11D48), size: 16),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Card 2: Join Care Plan
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CarePlanPage()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFEAECF0)),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Join Care Plan',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEE4E2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('Save extra', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFB42318))),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'on lab tests, online medicines & consultations',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Color(0xFF667085), height: 1.2),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            const Row(
                              children: [
                                Text(
                                  'Know More',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFE11D48)),
                                ),
                                Icon(Icons.chevron_right_rounded, color: Color(0xFFE11D48), size: 16),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // BOTTOM SECTION: FEATURES & EXPLANATION
            Container(
              width: double.infinity,
              color: const Color(0xFFF9FAFB),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AxioVital Care is now Trackcoins',
                    style: TextStyle(color: Color(0xFF475467), fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "It's bigger & better",
                    style: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "All your Trackcoins are safe in your account and are valid for lifetime.",
                    style: TextStyle(color: Color(0xFF475467), fontSize: 13, height: 1.4),
                  ),
                  
                  const SizedBox(height: 24),
                  const Text(
                    "What's new",
                    style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildFeatureRow(
                    Icons.inventory_2_outlined,
                    "No limit on how much you can redeem",
                    "Now you can redeem 100% of your Trackcoins at once when placing an order",
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureRow(
                    Icons.update_outlined,
                    "Points that never expire",
                    "Validity on points earned has been increased from 6 months to 1 year from your last transaction date",
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builder for the entirely STATIC falling coins layout with motion blur trails
  List<Widget> _buildStaticFallingCoins() {
    final random = math.Random(614); // Fixed seed to reproduce exact aesthetic arch
    final List<Widget> coins = [];
    
    // Generate 16 static coins in an arch layout imitating the screenshot
    for (int i = 0; i < 16; i++) {
      final size = 18.0 + random.nextDouble() * 32.0; // 18 to 50
      final xPos = -0.9 + (i / 15) * 1.8; // evenly distributed horizontally
      
      // Calculate arch height (higher in the middle, curving down at edges)
      // Alignment goes from -1.0 (top) to 1.0 (bottom)
      // We want the edges to be somewhat high (-0.6), dipping a tiny bit, and varying
      final distFromCenter = xPos.abs();
      // Arch curve logic: edges are lower on screen physically (higher Y value)
      final archCurve = -0.8 + (math.pow(distFromCenter, 2) * 0.4); 
      final finalY = archCurve + (random.nextDouble() * 0.2 - 0.1); // Add slight messy scatter
      
      final opacity = 0.5 + random.nextDouble() * 0.5; // 0.5 to 1.0
      final trailHeight = size * (0.8 + random.nextDouble() * 1.2); // Trail size relative to coin
      
      coins.add(
        Align(
          alignment: Alignment(xPos, finalY),
          child: Opacity(
            opacity: opacity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Upward motion blur trail (simulating falling)
                Container(
                  width: size * 0.5,
                  height: trailHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        const Color(0xFFFBBF24).withOpacity(0.55),
                        const Color(0xFFFBBF24).withOpacity(0.0),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(size),
                  ),
                ),
                // The static 3D coin image
                Image.network(
                  'https://cdn-icons-png.flaticon.com/512/5778/5778036.png',
                  width: size,
                  height: size,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.monetization_on,
                    color: const Color(0xFFFBBF24),
                    size: size,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return coins;
  }

  Widget _buildFeatureRow(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFEAECF0),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFD0D5DD)),
          ),
          child: Icon(icon, color: const Color(0xFF475467), size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Color(0xFF667085), fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
