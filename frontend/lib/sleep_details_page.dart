import 'package:flutter/material.dart';

class SleepDetailsPage extends StatelessWidget {
  const SleepDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F), // Deep black background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              _buildHeaderIcon(Icons.local_fire_department, "75", const Color(0xFFFF8447)),
              const SizedBox(width: 12),
              _buildHeaderIcon(Icons.emoji_events, "17", const Color(0xFFFFD700)),
            ],
          ),
        ),
        leadingWidth: 200,
        actions: [
          _buildActionIcon(Icons.help_outline),
          const SizedBox(width: 12),
          _buildActionIcon(Icons.settings_outlined),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.2),
            radius: 1.2,
            colors: [Color(0xFF1A1A1E), Color(0xFF0F0F0F)], // Spotlight gradient
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 60), // Space for status bar/header
                
                // 3D Badge Centerpiece
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Orbital Rings with improved opacity/blur
                        CustomPaint(
                          size: const Size(320, 320),
                          painter: _OrbitalPainter(),
                        ),
                        // The Badge (Multi-layered for '3D' look)
                        _buildPremiumBadge(),
                      ],
                    ),
                  ),
                ),

                // Bottom Stats Card (Matching the image)
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(36),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Sunday, Mar 8',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '10h 24m',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 54,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'total sleep time',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.3),
                          fontSize: 13,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Period Selector (D, W, M, Y)
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            _buildPeriodButton('D', true),
                            _buildPeriodButton('W', false),
                            _buildPeriodButton('M', false),
                            _buildPeriodButton('Y', false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Header Buttons
            Positioned(
              top: 10,
              left: 20,
              right: 20,
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildHeaderIcon(Icons.local_fire_department, "75", const Color(0xFFFF8447)),
                        const SizedBox(width: 10),
                        _buildHeaderIcon(Icons.emoji_events, "17", const Color(0xFFFFD700)),
                      ],
                    ),
                    Row(
                      children: [
                        _buildActionIcon(Icons.help_outline),
                        const SizedBox(width: 10),
                        _buildActionIcon(Icons.settings_outlined),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Back button
            Positioned(
              top: 60,
              left: 10,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white60, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumBadge() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF333333),
            const Color(0xFF111111),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1570EF).withOpacity(0.15),
            blurRadius: 40,
            spreadRadius: 5,
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.5),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Inner gloss
          Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.05), width: 2),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFA6C9FF), Color(0xFF4B89FF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: const Text(
                  '+10',
                  style: TextStyle(
                    fontSize: 84,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -6,
                    height: 1,
                  ),
                ),
              ),
              Text(
                'hr',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF8EBAFF).withOpacity(0.8),
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildPeriodButton(String label, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3A3A3C) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white24,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _OrbitalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = const Color(0xFF8EBAFF).withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw elliptical rings
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-0.5);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: size.width, height: size.height * 0.4),
      paint,
    );
    canvas.restore();

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(0.5);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: size.width * 0.8, height: size.height * 0.3),
      paint,
    );
    
    // Add some small glowing dots on rings
    final dotPaint = Paint()..color = const Color(0xFF8EBAFF);
    canvas.drawCircle(Offset(size.width * 0.4, 0), 2, dotPaint);
    canvas.drawCircle(Offset(-size.width * 0.2, size.height * 0.1), 3, dotPaint);
    
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
