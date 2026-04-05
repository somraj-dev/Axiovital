import 'package:flutter/material.dart';
import 'food_analysis_page.dart'; // We'll create this next

class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.more_horiz, color: Colors.black, size: 20),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const Text(
              'Nutrition',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Today, 14 September',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                ),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey.shade400),
              ],
            ),
            const SizedBox(height: 40),

            // Central Gauge
            SizedBox(
              height: 240,
              width: 240,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Cutlery Icons in Background
                  Positioned(
                    left: 20,
                    child: Icon(Icons.flatware_outlined, size: 40, color: Colors.grey.shade200),
                  ),
                  Positioned(
                    right: 20,
                    child: Icon(Icons.flatware_outlined, size: 40, color: Colors.grey.shade200),
                  ),
                  // The Gauge
                  CustomPaint(
                    size: const Size(200, 200),
                    painter: _NutritionGaugePainter(score: 83),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '83',
                        style: TextStyle(fontSize: 64, fontWeight: FontWeight.w800, color: Color(0xFF101828)),
                      ),
                      Text(
                        'optimal',
                        style: TextStyle(fontSize: 16, color: Color(0xFF6366F1).withOpacity(0.6), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // Action Buttons (Describe, Capture, Search)
            Row(
              children: [
                _buildActionButton(context, 'Describe', 'AI', Icons.text_fields),
                const SizedBox(width: 12),
                _buildActionButton(
                  context, 
                  'Capture', 
                  'Camera', 
                  Icons.camera_alt,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FoodAnalysisPage()));
                  }
                ),
                const SizedBox(width: 12),
                _buildActionButton(context, 'Search', 'Find', Icons.search),
              ],
            ),
            const SizedBox(height: 24),

            // Metrics Row (Food Quality, Glucose Impact)
            Row(
              children: [
                _buildMetricCard('Food Quality', '83', 'Optimal', Color(0xFF6366F1).withOpacity(0.6)),
                const SizedBox(width: 16),
                _buildMetricCard('Glucose Impact', '-', '', Colors.grey.shade400),
              ],
            ),
            const SizedBox(height: 24),

            // My Foods Row
            _buildMyFoodsCard(),
            const SizedBox(height: 32),

            // Goals Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Goals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF101828))),
                Icon(Icons.arrow_forward, size: 20, color: Colors.grey.shade400),
              ],
            ),
            const SizedBox(height: 16),
            _buildGoalsCard(),
            const SizedBox(height: 24),

            // Macro Nutrients Row
            Row(
              children: [
                _buildMacroCard('Fat', '25g left', 0.7, Colors.blue),
                const SizedBox(width: 12),
                _buildMacroCard('Carbs', '95g left', 0.4, Colors.orange),
                const SizedBox(width: 12),
                _buildMacroCard('Protein', '115g left', 0.2, Colors.pink.shade200),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, String sub, IconData icon, {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 40, offset: const Offset(0, 10)),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, size: 28, color: Colors.black87),
              const SizedBox(height: 12),
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF101828))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, String status, Color statusColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 40, offset: const Offset(0, 10)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome_mosaic_outlined, size: 14, color: Colors.grey.shade400),
                const SizedBox(width: 8),
                Text(title, style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 16),
            Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFF101828))),
            if (status.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMyFoodsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 40, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.menu_book_outlined, size: 24, color: Color(0xFF101828)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('My Foods', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF101828))),
                const SizedBox(height: 4),
                Text(
                  '0 favorites • 0 recipes • 2 foods',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward, size: 20, color: Colors.grey.shade300),
        ],
      ),
    );
  }

  Widget _buildGoalsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 40, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Calories', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF101828))),
              const Text('1,89K', style: TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.w700, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 4),
          Text('1.193 kcal left', style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
          const SizedBox(height: 24),
          // Bar Chart with one highlighted bar
          SizedBox(
            height: 45,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(12, (index) {
                final double h = [15.0, 20.0, 25.0, 18.0, 22.0, 35.0, 30.0, 40.0, 32.0, 28.0, 45.0, 38.0][index];
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: h,
                    decoration: BoxDecoration(
                      color: index == 10 ? const Color(0xFF6366F1) : const Color(0xFFF2F4F7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard(String label, String value, double progress, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 40, offset: const Offset(0, 10)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF101828))),
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 2.5,
                    color: color,
                    backgroundColor: const Color(0xFFF2F4F7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(color: Colors.grey.shade400, fontSize: 11, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _NutritionGaugePainter extends CustomPainter {
  final int score;
  _NutritionGaugePainter({required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;

    // Track (Light grey thin ring)
    final trackPaint = Paint()
      ..color = const Color(0xFFF2F4F7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, trackPaint);

    // Thick Outer Dotted Indicator (Simulated with dashes)
    final progressPaint = Paint()
      ..color = const Color(0xFF6366F1).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (score / 100) * 2 * 3.1415;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -3.1415 / 2, sweepAngle, false, progressPaint);

    // Inner tick marks
    final tickPaint = Paint()
      ..color = const Color(0xFFD0D5DD)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (var i = 0; i < 60; i++) {
        final double angle = (i * 6) * 3.1415 / 180;
        final double innerR = radius - 15;
        final double outerR = radius - 10;
        
        final Offset p1 = Offset(center.dx + innerR * 0.9 * 1, center.dy + innerR * 0.9 * 1); // Mock logic for speed
        // canvas.drawLine(p1, p2, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
