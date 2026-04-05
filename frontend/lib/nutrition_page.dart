import 'package:flutter/material.dart';
import 'food_analysis_page.dart';

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
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
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
            const Text('Nutrition', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Today, 14 September', style: TextStyle(color: Colors.grey.shade600, fontSize: 15)),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey.shade400),
              ],
            ),
            const SizedBox(height: 48),

            // Central Gauge
            SizedBox(
              height: 240,
              width: 240,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(size: const Size(200, 200), painter: _NutritionGaugePainter(score: 83)),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('83', style: TextStyle(fontSize: 64, fontWeight: FontWeight.w800, color: Color(0xFF101828))),
                      Text('optimal', style: TextStyle(fontSize: 16, color: const Color(0xFF6366F1).withOpacity(0.6), fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // Action Buttons
            Row(
              children: [
                _buildActionButton(context, 'Describe', 'AI', Icons.text_fields),
                const SizedBox(width: 12),
                _buildActionButton(context, 'Capture', 'Camera', Icons.camera_alt, onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FoodAnalysisPage()));
                }),
                const SizedBox(width: 12),
                _buildActionButton(context, 'Search', 'Find', Icons.search),
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
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 40, offset: const Offset(0, 10))],
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
}

class _NutritionGaugePainter extends CustomPainter {
  final int score;
  _NutritionGaugePainter({required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;

    final trackPaint = Paint()..color = const Color(0xFFF2F4F7)..style = PaintingStyle.stroke..strokeWidth = 4;
    canvas.drawCircle(center, radius, trackPaint);

    final progressPaint = Paint()
      ..color = const Color(0xFF6366F1).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (score / 100) * 2 * 3.1415;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -3.1415 / 2, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
