import 'package:flutter/material.dart';

class ProcessingPage extends StatelessWidget {
  final String type;

  const ProcessingPage({super.key, required this.type});

  String get _appBarTitle {
    switch (type) {
      case 'report':
        return 'Uploading report';
      case 'prescription':
        return 'Uploading prescription';
      case 'scan':
        return 'Uploading scan';
      default:
        return 'Uploading report';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // === CUSTOM APP BAR (left-aligned, exactly like reference) ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _appBarTitle,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        'for Somraj',
                        style: TextStyle(
                          color: Color(0xFF667085),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Thin divider line
            Divider(color: Colors.grey.shade200, height: 1, thickness: 1),

            // === SCROLLABLE CONTENT ===
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // === PROGRESS BAR (3 of 3, all green) ===
                    Row(
                      children: [
                        const Text(
                          '3 of 3',
                          style: TextStyle(
                            color: Color(0xFF039855),
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 16),
                        _buildProgressSegment(true),
                        const SizedBox(width: 6),
                        _buildProgressSegment(true),
                        const SizedBox(width: 6),
                        _buildProgressSegment(true),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // === HEADING (left aligned, exactly like reference) ===
                    const Text(
                      'Processing your report',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        color: Color(0xFF101828),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Generating in-depth analysis from your report',
                      style: TextStyle(
                        color: Color(0xFF667085),
                        fontSize: 15,
                      ),
                    ),

                    // === CENTER CONTENT ===
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Document illustration with scan line
                          SizedBox(
                            width: 180,
                            height: 160,
                            child: CustomPaint(
                              painter: _ScanningDocumentPainter(),
                            ),
                          ),

                          const SizedBox(height: 48),

                          // Large bold text (exactly like reference)
                          const Text(
                            'Hang tight, we are processing your radiology report!',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 24,
                              height: 1.3,
                              color: Color(0xFF101828),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'This will take about 1 minute. You can close the screen, we\'ll notify you when it\'s ready.',
                            style: TextStyle(
                              color: Color(0xFF667085),
                              fontSize: 16,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // === FOOTER ===
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Column(
                children: [
                  // Digitising button (disabled/grey state)
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEAECF0),
                        disabledBackgroundColor: const Color(0xFFEAECF0),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        'Digitising...',
                        style: TextStyle(
                          color: Color(0xFF98A2B3),
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // AI text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'The report will be processed using AI',
                        style: TextStyle(color: Color(0xFF98A2B3), fontSize: 13),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right, size: 16, color: Color(0xFF98A2B3)),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSegment(bool active) {
    return Expanded(
      child: Container(
        height: 8,
        decoration: BoxDecoration(
          color: active ? const Color(0xFF039855) : const Color(0xFFEAECF0),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// Custom painter: flat document with "REPORT" label, lines, and a blue scan line
class _ScanningDocumentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Shadow beneath document
    final shadowPaint = Paint()
      ..color = const Color(0xFFE4E7EC).withOpacity(0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.2, size.height * 0.1, size.width * 0.6, size.height * 0.85),
        const Radius.circular(6),
      ),
      shadowPaint,
    );

    // Main document body
    final docPaint = Paint()..color = const Color(0xFFF8F9FC);
    final docBorder = Paint()
      ..color = const Color(0xFFE4E7EC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final docRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.15, size.height * 0.05, size.width * 0.7, size.height * 0.85),
      const Radius.circular(4),
    );
    canvas.drawRRect(docRect, docPaint);
    canvas.drawRRect(docRect, docBorder);

    // Folded corner
    final foldSize = size.width * 0.18;
    final foldX = size.width * 0.67;
    final foldY = size.height * 0.05;

    final foldPath = Path();
    foldPath.moveTo(foldX, foldY);
    foldPath.lineTo(foldX + foldSize, foldY + foldSize);
    foldPath.lineTo(foldX + foldSize, foldY);
    foldPath.close();
    canvas.drawPath(foldPath, Paint()..color = const Color(0xFFE4E7EC));

    final foldFlap = Path();
    foldFlap.moveTo(foldX, foldY);
    foldFlap.lineTo(foldX, foldY + foldSize);
    foldFlap.lineTo(foldX + foldSize, foldY + foldSize);
    foldFlap.close();
    canvas.drawPath(foldFlap, Paint()..color = const Color(0xFFD0D5DD).withOpacity(0.4));

    // "REPORT" label
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'REPORT',
        style: TextStyle(
          color: Color(0xFF039855),
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width * 0.25, size.height * 0.2));

    // Horizontal lines
    final linePaint = Paint()
      ..color = const Color(0xFFE4E7EC)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 4; i++) {
      final y = size.height * (0.38 + i * 0.11);
      canvas.drawLine(
        Offset(size.width * 0.25, y),
        Offset(size.width * 0.70, y),
        linePaint,
      );
    }

    // === BLUE SCAN LINE (key visual from reference) ===
    final scanY = size.height * 0.35;
    final scanPaint = Paint()
      ..color = const Color(0xFF2E90FA)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.12, scanY),
      Offset(size.width * 0.88, scanY),
      scanPaint,
    );

    // Glow effect on scan line
    final glowPaint = Paint()
      ..color = const Color(0xFF2E90FA).withOpacity(0.15)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawLine(
      Offset(size.width * 0.12, scanY),
      Offset(size.width * 0.88, scanY),
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
