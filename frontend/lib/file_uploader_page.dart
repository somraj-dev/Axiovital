import 'package:flutter/material.dart';
import 'processing_page.dart';

class FileUploaderPage extends StatefulWidget {
  final String type;

  const FileUploaderPage({super.key, required this.type});

  @override
  State<FileUploaderPage> createState() => _FileUploaderPageState();
}

class _FileUploaderPageState extends State<FileUploaderPage> {
  bool isFileSelected = false;

  String get _typeLabel {
    switch (widget.type) {
      case 'report':
        return 'report';
      case 'prescription':
        return 'prescription';
      case 'scan':
        return 'scan';
      default:
        return 'report';
    }
  }

  String get _typeCapitalized {
    switch (widget.type) {
      case 'report':
        return 'report';
      case 'prescription':
        return 'Prescription';
      case 'scan':
        return 'scan';
      default:
        return 'report';
    }
  }

  String get _appBarTitle {
    switch (widget.type) {
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

  String get _footerAiText {
    switch (widget.type) {
      case 'report':
        return 'The report will be processed using AI';
      case 'prescription':
        return 'The prescription will be processed using AI';
      case 'scan':
        return 'The report will be processed using AI';
      default:
        return 'The report will be processed using AI';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // === CUSTOM APP BAR (left-aligned title, exactly like reference) ===
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

            // Thin divider line (exactly like reference)
            Divider(color: Colors.grey.shade200, height: 1, thickness: 1),

            // === SCROLLABLE CONTENT ===
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // === PROGRESS BAR (2 of 3) ===
                      Row(
                        children: [
                          const Text(
                            '2 of 3',
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
                          _buildProgressSegment(false),
                        ],
                      ),
                      const SizedBox(height: 20),

                      if (!isFileSelected) ...[
                        // === INITIAL UPLOAD STATE ===
                        Text(
                          'Upload a $_typeCapitalized',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            color: Color(0xFF101828),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'from your device',
                          style: TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 60),

                        // === DOCUMENT ILLUSTRATION (flat paper with REPORT label) ===
                        Center(
                          child: SizedBox(
                            width: 180,
                            height: 160,
                            child: CustomPaint(
                              painter: _DocumentPainter(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // === DASHED UPLOAD BOX ===
                        GestureDetector(
                          onTap: () => setState(() => isFileSelected = true),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1.5,
                                // Note: Flutter doesn't natively support dashed borders
                                // Using a DashPainter via CustomPaint for accuracy
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.upload, color: Colors.grey.shade600, size: 32),
                                const SizedBox(height: 12),
                                Text(
                                  'Upload a $_typeLabel',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                    color: Color(0xFF101828),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // === "What you can upload" section (for scan type) ===
                        if (widget.type == 'scan') ...[
                          const SizedBox(height: 28),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'What you can upload',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Color(0xFF101828),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'MRI, CT Scan, X- ray, Ultrasound and many more',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildSampleImage(),
                                    const SizedBox(width: 12),
                                    _buildSampleImage(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ] else ...[
                        // === VERIFICATION STATE (Report uploaded) ===
                        const Text(
                          'Report uploaded',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            color: Color(0xFF101828),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Your lab report is ready for analysis.',
                          style: TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // === FILE CARD ===
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFEAECF0), width: 1),
                          ),
                          child: Row(
                            children: [
                              // PDF icon (document with PDF badge)
                              SizedBox(
                                width: 44,
                                height: 48,
                                child: CustomPaint(
                                  painter: _PdfIconPainter(),
                                ),
                              ),
                              const SizedBox(width: 14),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Screenshot_2026-04-04-01-58-2...',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Color(0xFF101828),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'File attached',
                                      style: TextStyle(
                                        color: Color(0xFF667085),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => isFileSelected = false),
                                child: Icon(Icons.close, color: Colors.grey.shade400, size: 22),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // === FORM FIELDS (Outlined with floating labels) ===
                        _buildOutlinedField('What is the test name?*', 'Bone'),
                        const SizedBox(height: 20),
                        _buildOutlinedField('Test Type (e.g., MRI, CT Scan, X-Ray)', 'X Ray'),
                        const SizedBox(height: 20),
                        _buildOutlinedField('Which lab did you take the test from?', 'Deen Dayal Upadhyay'),
                        const SizedBox(height: 20),
                        _buildOutlinedField('Date of test taken*', '03/04/2026'),
                      ],
                      const SizedBox(height: 40),

                      // === "Here's how it helps you" ===
                      Row(
                        children: [
                          const Text(
                            "Here\u2019s how it helps you",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 19,
                              color: Color(0xFF101828),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Divider(color: Colors.grey.shade300, thickness: 1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // === BENEFIT ITEMS ===
                      _buildBenefitItem(
                        Icons.favorite,
                        'Unified Health Tracking',
                        'Track all your health data in one place',
                        const Color(0xFFFCE7F6),
                        const Color(0xFFE56B93),
                      ),
                      const SizedBox(height: 24),
                      _buildBenefitItem(
                        Icons.bar_chart_rounded,
                        'AI Powered Insights',
                        'Easy to understand explanation of document',
                        const Color(0xFFF0EFFF),
                        const Color(0xFF7B5CAB),
                      ),
                      const SizedBox(height: 24),
                      _buildBenefitItem(
                        Icons.assignment_rounded,
                        'Actionable next steps',
                        'Learn what you can do next - lifestyle changes, follow-ups, or questions to ask your doctor.',
                        const Color(0xFFFFF1EB),
                        const Color(0xFFE58D61),
                      ),

                      const SizedBox(height: 40),

                      // === BOTTOM 3D CHARACTER ILLUSTRATION ===
                      SizedBox(
                        width: double.infinity,
                        child: Image.network(
                          'https://cdni.iconscout.com/illustration/premium/thumb/woman-checking-medical-report-illustration-download-in-svg-png-gif-file-formats--health-checkup-doctor-healthcare-pack-people-illustrations-6020872.png',
                          height: 320,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              'https://img.freepik.com/free-photo/3d-rendering-cartoon-like-woman-working_23-2151337851.jpg',
                              height: 320,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // === FOOTER ===
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Purple banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  color: const Color(0xFF7B3C8C),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      children: [
                        const TextSpan(text: 'You are uploading a report for '),
                        TextSpan(
                          text: 'Somraj',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                ),
                // Continue button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: isFileSelected
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProcessingPage(type: widget.type),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFileSelected
                            ? const Color(0xFFF04438)
                            : const Color(0xFFEAECF0),
                        disabledBackgroundColor: const Color(0xFFEAECF0),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: isFileSelected ? Colors.white : const Color(0xFF98A2B3),
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
                // AI text
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _footerAiText,
                        style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 13),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right, size: 16, color: Color(0xFF98A2B3)),
                    ],
                  ),
                ),
              ],
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

  Widget _buildOutlinedField(String label, String value) {
    return TextFormField(
      initialValue: value,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: Color(0xFF101828),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFF667085),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF039855), width: 1.5),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(Icons.cancel_outlined, color: Colors.grey.shade400, size: 22),
        ),
        suffixIconConstraints: const BoxConstraints(minHeight: 22, minWidth: 22),
      ),
    );
  }

  Widget _buildSampleImage() {
    return Container(
      width: 140,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Center(
              child: CustomPaint(
                size: const Size(80, 70),
                painter: _DocumentPainter(),
              ),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'REPORT',
                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF039855)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String subtitle, Color bgColor, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: Color(0xFF101828),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF667085),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Custom painter for the flat document illustration (matches reference exactly)
class _DocumentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFF2F4F7);
    final borderPaint = Paint()
      ..color = const Color(0xFFE4E7EC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Main document body
    final docRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.15, size.height * 0.05, size.width * 0.7, size.height * 0.9),
      const Radius.circular(4),
    );
    canvas.drawRRect(docRect, paint);
    canvas.drawRRect(docRect, borderPaint);

    // Folded corner
    final foldPath = Path();
    final foldX = size.width * 0.65;
    final foldY = size.height * 0.05;
    final foldSize = size.width * 0.2;
    foldPath.moveTo(foldX, foldY);
    foldPath.lineTo(foldX + foldSize, foldY + foldSize);
    foldPath.lineTo(foldX + foldSize, foldY);
    foldPath.close();
    canvas.drawPath(foldPath, Paint()..color = const Color(0xFFE4E7EC));

    final foldFlapPath = Path();
    foldFlapPath.moveTo(foldX, foldY);
    foldFlapPath.lineTo(foldX, foldY + foldSize);
    foldFlapPath.lineTo(foldX + foldSize, foldY + foldSize);
    foldFlapPath.close();
    canvas.drawPath(foldFlapPath, Paint()..color = const Color(0xFFD0D5DD).withOpacity(0.5));

    // "REPORT" label
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'REPORT',
        style: TextStyle(
          color: Color(0xFF039855),
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width * 0.25, size.height * 0.22));

    // Horizontal lines (representing text)
    final linePaint = Paint()
      ..color = const Color(0xFFE4E7EC)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 4; i++) {
      final y = size.height * (0.42 + i * 0.12);
      canvas.drawLine(
        Offset(size.width * 0.25, y),
        Offset(size.width * 0.72, y),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for the PDF icon (matches reference exactly)
class _PdfIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Document body
    final docPaint = Paint()..color = const Color(0xFFF2F4F7);
    final docBorder = Paint()
      ..color = const Color(0xFFD0D5DD)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final docPath = Path();
    docPath.moveTo(0, 4);
    docPath.lineTo(0, size.height - 4);
    docPath.quadraticBezierTo(0, size.height, 4, size.height);
    docPath.lineTo(size.width - 4, size.height);
    docPath.quadraticBezierTo(size.width, size.height, size.width, size.height - 4);
    docPath.lineTo(size.width, 12);
    docPath.lineTo(size.width - 12, 0);
    docPath.lineTo(4, 0);
    docPath.quadraticBezierTo(0, 0, 0, 4);
    docPath.close();

    canvas.drawPath(docPath, docPaint);
    canvas.drawPath(docPath, docBorder);

    // Folded corner
    final foldPath = Path();
    foldPath.moveTo(size.width - 12, 0);
    foldPath.lineTo(size.width - 12, 12);
    foldPath.lineTo(size.width, 12);
    foldPath.close();
    canvas.drawPath(foldPath, Paint()..color = const Color(0xFFD0D5DD));

    // "PDF" badge at bottom
    final badgeRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(2, size.height - 18, 28, 14),
      const Radius.circular(3),
    );
    canvas.drawRRect(badgeRect, Paint()..color = const Color(0xFFD92D20));

    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'PDF',
        style: TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(8, size.height - 16));

    // Lines inside document
    final linePaint = Paint()
      ..color = const Color(0xFFE4E7EC)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 3; i++) {
      final y = 18.0 + i * 7;
      canvas.drawLine(Offset(8, y), Offset(size.width - 10, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
