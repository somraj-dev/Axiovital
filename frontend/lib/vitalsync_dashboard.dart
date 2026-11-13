import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'profile_drawer.dart';
import 'notification_page.dart';
import 'search_page.dart';
import 'notification_provider.dart';
import 'device_connectivity_page.dart';
import 'fitleague_page.dart';
import 'partner_hospitals_page.dart';

class VitalSyncDashboard extends StatefulWidget {
  const VitalSyncDashboard({super.key});

  @override
  State<VitalSyncDashboard> createState() => _VitalSyncDashboardState();
}

class _VitalSyncDashboardState extends State<VitalSyncDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF000000),
      drawer: const ProfileDrawer(),
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Bar: Profile Avatar, Search Bar, Gift Icon, Bell Icon
              _buildTopBar(context),
              const SizedBox(height: 18),

              // 2. Hero "Wallet" Card
              _buildWalletCard(context),
              const SizedBox(height: 14),

              // 3. Side-by-Side: "Spending" & "Cash Back"
              _buildSpendingAndCashbackRow(),
              const SizedBox(height: 14),

              // 4. Quick Actions: Stacked [QR / +] + "Tips And Training" + "All Services"
              _buildQuickActionsRow(context),
              const SizedBox(height: 14),

              // 5. "Refer and Earn" Banner with 3D Sphere & Liquid Splash
              _buildReferAndEarnBanner(context),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 1. TOP BAR
  // ─────────────────────────────────────────────────────────────
  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        // Profile Avatar -> opens ProfileDrawer
        GestureDetector(
          onTap: () => _scaffoldKey.currentState?.openDrawer(),
          child: Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: ClipOval(
              child: Image.network(
                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=300&auto=format&fit=crop',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF222222),
                  child: const Icon(Icons.person, color: Colors.white, size: 24),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Rounded Search Bar -> opens SearchPage
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchPage()),
              );
            },
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.search_rounded,
                    color: Color(0xFF6B6B6B),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Search',
                    style: TextStyle(
                      color: Color(0xFF6B6B6B),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Gift / Rewards Icon
        GestureDetector(
          onTap: () => _showQuickNotice(context, 'Rewards unlocked!'),
          child: const Icon(
            Icons.card_giftcard_outlined,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(width: 14),

        // Notification Bell -> opens NotificationPage
        Consumer<NotificationProvider>(
          builder: (context, notifProvider, _) => GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationPage()),
              );
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 23,
                ),
                if (notifProvider.unreadCount > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF3B30),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 2. HERO "WALLET" CARD
  // ─────────────────────────────────────────────────────────────
  Widget _buildWalletCard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 216,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const RadialGradient(
          center: Alignment(0.65, -0.85),
          radius: 1.4,
          colors: [
            Color(0xFF2E2E2E), // diffused top-right specular glow
            Color(0xFF1E1E1E),
            Color(0xFF131313),
            Color(0xFF101010),
          ],
          stops: [0.0, 0.35, 0.75, 1.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: "Wallet" and "+"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Wallet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () => _showAddMoneyModal(context),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ),

          // User Name: "Josh Hill"
          const Text(
            'Josh Hill',
            style: TextStyle(
              color: Color(0xFF7A7A7A),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),

          // Big Balance: "$15,630.71"
          const Text(
            '\$15,630.71',
            style: TextStyle(
              color: Colors.white,
              fontSize: 33,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),

          // Bottom Row: "Account ** 5087" and Mastercard logo + "**** 3264"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Account ** 5087',
                style: TextStyle(
                  color: Color(0xFF6B6B6B),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                children: [
                  _buildMastercardLogo(),
                  const SizedBox(width: 8),
                  const Text(
                    '**** 3264',
                    style: TextStyle(
                      color: Color(0xFF6B6B6B),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMastercardLogo() {
    return SizedBox(
      width: 28,
      height: 18,
      child: Stack(
        children: [
          // Left circle: Red
          Positioned(
            left: 0,
            top: 1,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Color(0xFFEB001B),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Right circle: Orange with blend
          Positioned(
            right: 0,
            top: 1,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFFF79E1B).withOpacity(0.92),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 3. SPENDING & CASH BACK
  // ─────────────────────────────────────────────────────────────
  Widget _buildSpendingAndCashbackRow() {
    return Row(
      children: [
        // Left: "Spending"
        Expanded(
          child: Container(
            height: 114,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Spending',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Spent in October',
                      style: TextStyle(
                        color: Color(0xFF6B6B6B),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                // Capsule progress segments
                _buildSegmentedSpendingPills(),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Right: "Cash Back"
        Expanded(
          child: Container(
            height: 114,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cash Back',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // 4 Brand Badges (Netflix, EL, Nike, McDonald's)
                _buildCashbackBrandBadges(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentedSpendingPills() {
    return Row(
      children: [
        // Purple pill
        Container(
          width: 44,
          height: 15,
          decoration: BoxDecoration(
            color: const Color(0xFF6E2CF4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 5),
        // Coral pill
        Container(
          width: 24,
          height: 15,
          decoration: BoxDecoration(
            color: const Color(0xFFFF4949),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 5),
        // Teal pill
        Container(
          width: 9,
          height: 15,
          decoration: BoxDecoration(
            color: const Color(0xFF009E74),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 5),
        // Yellow pill
        Container(
          width: 19,
          height: 15,
          decoration: BoxDecoration(
            color: const Color(0xFFFFBF00),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 5),
        // Blue pill
        Container(
          width: 9,
          height: 15,
          decoration: BoxDecoration(
            color: const Color(0xFF1E75FF),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }

  Widget _buildCashbackBrandBadges() {
    return Row(
      children: [
        // 1. Netflix (Black with red N)
        _brandBadge(
          bgColor: Colors.black,
          child: const Text(
            'N',
            style: TextStyle(
              color: Color(0xFFE50914),
              fontWeight: FontWeight.w900,
              fontSize: 15,
              height: 1.1,
            ),
          ),
        ),
        const SizedBox(width: 4),

        // 2. EL (White with black italic serif EL)
        _brandBadge(
          bgColor: Colors.white,
          child: const Text(
            'EL',
            style: TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              fontFamily: 'serif',
            ),
          ),
        ),
        const SizedBox(width: 4),

        // 3. Nike (Black with white Swoosh)
        _brandBadge(
          bgColor: Colors.black,
          child: CustomPaint(
            size: const Size(14, 8),
            painter: _NikeSwooshPainter(),
          ),
        ),
        const SizedBox(width: 4),

        // 4. McDonald's (Red with golden M)
        _brandBadge(
          bgColor: const Color(0xFFDA291C),
          child: const Text(
            'M',
            style: TextStyle(
              color: Color(0xFFFFC72C),
              fontWeight: FontWeight.w900,
              fontSize: 13,
              fontFamily: 'sans-serif',
              height: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _brandBadge({required Color bgColor, required Widget child}) {
    return Container(
      width: 27,
      height: 27,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(child: child),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 4. QUICK ACTIONS ROW
  // ─────────────────────────────────────────────────────────────
  Widget _buildQuickActionsRow(BuildContext context) {
    return Row(
      children: [
        // Stacked [QR Scanner / + Button]
        Column(
          children: [
            // QR Code Scanner Button
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DeviceConnectivityPage()),
                );
              },
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: CustomPaint(
                    size: const Size(20, 20),
                    painter: _QrScannerIconPainter(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Plus Button
            GestureDetector(
              onTap: () => _showAddMoneyModal(context),
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),

        // "Tips And Training" Card
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FitLeaguePage()),
              );
            },
            child: Container(
              height: 114,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFF222222),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.school_outlined,
                        color: Colors.white,
                        size: 19,
                      ),
                    ),
                  ),
                  const Text(
                    'Tips And Training',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // "All Services" Card
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PartnerHospitalsPage()),
              );
            },
            child: Container(
              height: 114,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF141414),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFF222222),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: _buildFourSquareIcon(),
                    ),
                  ),
                  const Text(
                    'All Services',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFourSquareIcon() {
    return SizedBox(
      width: 16,
      height: 16,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _tinySquare(),
              _tinySquare(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _tinySquare(),
              _tinySquare(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tinySquare() {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(1.5),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 5. REFER AND EARN PROMO BANNER
  // ─────────────────────────────────────────────────────────────
  Widget _buildReferAndEarnBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 134,
      padding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          // Left: Title, subtitle, "Learn more" button
          Expanded(
            flex: 13,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Refer and Earn',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Share a referral link to your\nfriend and get rewarded',
                      style: TextStyle(
                        color: Color(0xFF6B6B6B),
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => _showQuickNotice(context, 'Referral link copied!'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF222222),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Learn more',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Right: 3D Glossy Sphere and Liquid Particle Ring
          Expanded(
            flex: 10,
            child: SizedBox(
              height: 100,
              child: CustomPaint(
                painter: _DarkSphereAndLiquidSplashPainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMoneyModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161616),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Money to Wallet',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Linked to Account ** 5087 and Mastercard **** 3264',
              style: TextStyle(color: Color(0xFF7A7A7A), fontSize: 13),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E2E2E),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Add \$500.00', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickNotice(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF222222),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CUSTOM PAINTERS FOR PIXEL-PERFECT ICONS & 3D ART
// ─────────────────────────────────────────────────────────────

/// Paints the QR Scanner icon with brackets and central dots
class _QrScannerIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    const cornerLength = 5.0;

    // Top-Left
    canvas.drawLine(const Offset(0, cornerLength), const Offset(0, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(cornerLength, 0), paint);

    // Top-Right
    canvas.drawLine(Offset(size.width - cornerLength, 0), Offset(size.width, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), paint);

    // Bottom-Left
    canvas.drawLine(Offset(0, size.height - cornerLength), Offset(0, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), paint);

    // Bottom-Right
    canvas.drawLine(Offset(size.width - cornerLength, size.height), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height - cornerLength), Offset(size.width, size.height), paint);

    // Center QR mini blocks
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.28, size.height * 0.28, 4, 4), const Radius.circular(1)), dotPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.56, size.height * 0.28, 4, 4), const Radius.circular(1)), dotPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.28, size.height * 0.56, 4, 4), const Radius.circular(1)), dotPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.56, size.height * 0.56, 4, 4), const Radius.circular(1)), dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Paints the Nike Swoosh curve
class _NikeSwooshPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.5);
    path.cubicTo(
      size.width * 0.2, size.height * 0.95,
      size.width * 0.55, size.height * 0.95,
      size.width, 0,
    );
    path.cubicTo(
      size.width * 0.6, size.height * 0.75,
      size.width * 0.25, size.height * 0.7,
      size.width * 0.1, size.height * 0.45,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Paints the 3D Black Glossy Sphere and ethereal liquid splash ring
class _DarkSphereAndLiquidSplashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.58, size.height * 0.52);
    final sphereRadius = size.height * 0.32;

    // 1. Splash Particle Arc
    final particlePaint = Paint()
      ..color = const Color(0xFF6B6B6B)
      ..style = PaintingStyle.fill;

    final arcPaint = Paint()
      ..color = const Color(0xFF383838)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Splash orbital ring
    canvas.drawArc(
      Rect.fromCircle(center: Offset(center.dx - 10, center.dy - 6), radius: sphereRadius + 14),
      -math.pi * 0.8,
      math.pi * 1.4,
      false,
      arcPaint,
    );

    // Liquid droplets along top-left
    canvas.drawCircle(Offset(center.dx - 32, center.dy - 22), 2.2, particlePaint);
    canvas.drawCircle(Offset(center.dx - 22, center.dy - 32), 1.6, particlePaint);
    canvas.drawCircle(Offset(center.dx - 10, center.dy - 38), 2.8, particlePaint);
    canvas.drawCircle(Offset(center.dx + 4, center.dy - 40), 1.8, particlePaint);
    canvas.drawCircle(Offset(center.dx - 38, center.dy - 8), 2.0, particlePaint);
    canvas.drawCircle(Offset(center.dx - 34, center.dy + 8), 1.5, particlePaint);
    canvas.drawCircle(Offset(center.dx - 18, center.dy + 26), 2.4, particlePaint);

    // 2. Main 3D Glossy Sphere
    final spherePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.4, -0.4),
        radius: 0.9,
        colors: const [
          Color(0xFF555555),
          Color(0xFF242424),
          Color(0xFF0F0F0F),
          Color(0xFF000000),
        ],
        stops: const [0.0, 0.35, 0.75, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: sphereRadius));

    canvas.drawCircle(center, sphereRadius, spherePaint);

    // Specular highlight crescent
    final highlightPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.45, -0.45),
        radius: 0.35,
        colors: [
          Colors.white.withOpacity(0.35),
          Colors.white.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: sphereRadius));

    canvas.drawCircle(center, sphereRadius, highlightPaint);

    // 3. Mini Floating Droplet Sphere at bottom-right
    final miniCenter = Offset(center.dx + 26, center.dy + 22);
    const miniRadius = 9.0;

    final miniSpherePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.35),
        radius: 0.8,
        colors: const [
          Color(0xFF6E6E6E),
          Color(0xFF282828),
          Color(0xFF080808),
        ],
      ).createShader(Rect.fromCircle(center: miniCenter, radius: miniRadius));

    canvas.drawCircle(miniCenter, miniRadius, miniSpherePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
