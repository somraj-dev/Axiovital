import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'bluetooth_provider.dart';

class HealthInsightsPage extends StatefulWidget {
  const HealthInsightsPage({super.key});

  @override
  State<HealthInsightsPage> createState() => _HealthInsightsPageState();
}

class _HealthInsightsPageState extends State<HealthInsightsPage> {
  int _scanMode = 0;
  int _timeRange = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1214),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // 1. Body Scan Card
              _bodyScanCard(),
              const SizedBox(height: 16),
              // Scan Mode Tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _scanModeTabs(),
              ),
              const SizedBox(height: 28),
              // 2. Metric Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _metricsRow(),
              ),
              const SizedBox(height: 36),
              // 3. AI Anomaly Flags
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _anomalyHeader(),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _hypertensionCard(),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _sleepApneaCard(),
              ),
              const SizedBox(height: 40),
              // 4. Integrated Timeline
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _timelineHeader(),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _timelineChart(),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ─── BODY SCAN ───
  Widget _bodyScanCard() {
    return Container(
      height: 420,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF111B1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1C2A2D)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _GridDots())),

          // Clean body scan image
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Image.asset(
                'assets/images/body_scan.png',
                height: 350,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // CARDIAC ANOMALY label
          Positioned(
            top: 110,
            left: 16,
            child: Row(
              children: [
                Container(
                  width: 7, height: 7,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: const Color(0xFFEF4444).withOpacity(0.5), blurRadius: 6)],
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xCC000000),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('CARDIAC ANOMALY',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
                ),
              ],
            ),
          ),

          // GLUCOSE label
          Positioned(
            top: 200,
            right: 40,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xCC000000),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('GLUCOSE: 142',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.8)),
            ),
          ),

          // Health Score Top-Right
          Positioned(top: 12, right: 12, child: _healthScore()),
        ],
      ),
    );
  }

  Widget _healthScore() {
    return Container(
      width: 105,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xE6101A1D),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1E2E31)),
      ),
      child: Column(
        children: [
          const Text('HEALTH SCORE',
              style: TextStyle(color: Color(0xFF7A8A8D), fontSize: 7, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
          const SizedBox(height: 10),
          SizedBox(
            width: 62, height: 62,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(size: const Size(62, 62), painter: _ArcPainter(0.84)),
                const Text('84', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(color: const Color(0xFF1A2D20), borderRadius: BorderRadius.circular(6)),
            child: const Text('-2.4%', style: TextStyle(color: Color(0xFFEF4444), fontSize: 10, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ─── SCAN TABS ───
  Widget _scanModeTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(3, (i) {
          final labels = ['Full Scan', 'Cardiovascular', 'Endocrine'];
          final sel = _scanMode == i;
          return Padding(
            padding: EdgeInsets.only(right: i < 2 ? 10 : 0),
            child: GestureDetector(
              onTap: () => setState(() => _scanMode = i),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                decoration: BoxDecoration(
                  color: sel ? const Color(0xFF0EA5E9) : const Color(0xFF172023),
                  borderRadius: BorderRadius.circular(24),
                  border: sel ? null : Border.all(color: const Color(0xFF243033)),
                ),
                child: Text(labels[i],
                    style: TextStyle(
                        color: sel ? Colors.white : const Color(0xFF8A9A9D),
                        fontSize: 13, fontWeight: FontWeight.w700)),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ─── METRIC CARDS ───
  Widget _metricsRow() {
    return Consumer<BluetoothProvider>(
      builder: (context, btProvider, child) {
        final hr = (btProvider.isConnected && btProvider.heartRate > 0) ? '${btProvider.heartRate}' : '102';
        final glucose = (btProvider.isConnected && btProvider.glucose > 0) ? '${btProvider.glucose}' : '142';
        final spo2 = (btProvider.isConnected && btProvider.spo2 > 0) ? '${btProvider.spo2}' : '98';

        return Row(
          children: [
            Expanded(child: _metric(Icons.favorite, 'HEART RATE', hr, 'bpm', const Color(0xFFED4245))),
            const SizedBox(width: 10),
            Expanded(child: _metric(Icons.water_drop, 'GLUCOSE', glucose, 'mg/dL', const Color(0xFF3B82F6))),
            const SizedBox(width: 10),
            Expanded(child: _metric(Icons.air, 'SPO2', spo2, '%', const Color(0xFF22C55E))),
          ],
        );
      },
    );
  }

  Widget _metric(IconData icon, String label, String val, String unit, Color c) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111B1E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1C2A2D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: c, size: 13),
            const SizedBox(width: 6),
            Flexible(child: Text(label, overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF5A6A6D), fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: 0.5))),
          ]),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(val, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
              const SizedBox(width: 4),
              Text(unit, style: const TextStyle(color: Color(0xFF4A5A5D), fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  // ─── ANOMALY HEADER ───
  Widget _anomalyHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          ShaderMask(
            shaderCallback: (b) => const LinearGradient(colors: [Color(0xFF00D4FF), Color(0xFF7C3AED)]).createShader(b),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          const Text('AI Anomaly Flags', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
        ]),
        const Text('2 Active', style: TextStyle(color: Color(0xFF00D4FF), fontSize: 13, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic)),
      ],
    );
  }

  // ─── ANOMALY CARDS ───
  Widget _hypertensionCard() => _anomalyCard(
    title: 'Hypertension Alert',
    desc: 'Medication not showing expected impact. BP remains elevated 4h post-Lisinopril.',
    primary: 'Adjust Plan', secondary: 'Ignore', accent: const Color(0xFFF59E0B),
  );

  Widget _sleepApneaCard() => _anomalyCard(
    title: 'Sleep Apnea Prediction',
    desc: 'O2 saturation dips below 90% during REM phases over the last 3 nights.',
    primary: 'Order Lab', secondary: null, accent: const Color(0xFF06B6D4),
  );

  Widget _anomalyCard({required String title, required String desc, required String primary, String? secondary, required Color accent}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111B1E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1C2A2D)),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4, color: accent),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text(desc, style: const TextStyle(color: Color(0xFF7A8A8D), fontSize: 12, height: 1.5)),
                        const SizedBox(height: 14),
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                            decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(12)),
                            child: Text(primary, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                          ),
                          if (secondary != null) ...[
                            const SizedBox(width: 12),
                            Text(secondary, style: const TextStyle(color: Color(0xFF7A8A8D), fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ]),
                      ],
                    )),
                    const SizedBox(width: 12),
                    Container(
                      width: 85, height: 85,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A1214),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF1C2A2D)),
                      ),
                      child: CustomPaint(painter: _WavePainter(accent)),
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

  // ─── TIMELINE ───
  Widget _timelineHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Integrated Timeline', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
        Row(children: List.generate(3, (i) {
          final labels = ['24H', '7D', '30D'];
          final sel = _timeRange == i;
          return GestureDetector(
            onTap: () => setState(() => _timeRange = i),
            child: Padding(
              padding: EdgeInsets.only(left: i > 0 ? 12 : 0),
              child: Text(labels[i], style: TextStyle(
                color: sel ? const Color(0xFF00D4FF) : const Color(0xFF4A5A5D),
                fontSize: 12, fontWeight: FontWeight.w800,
              )),
            ),
          );
        })),
      ],
    );
  }

  Widget _timelineChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111B1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1C2A2D)),
      ),
      child: Column(children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('MON', style: TextStyle(color: Color(0xFF4A5A5D), fontSize: 10, fontWeight: FontWeight.w700)),
            Text('TUE', style: TextStyle(color: Color(0xFF4A5A5D), fontSize: 10, fontWeight: FontWeight.w700)),
            Text('WED', style: TextStyle(color: Color(0xFF4A5A5D), fontSize: 10, fontWeight: FontWeight.w700)),
            Text('TODAY', style: TextStyle(color: Color(0xFF00D4FF), fontSize: 10, fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(height: 140, width: double.infinity, child: CustomPaint(painter: _ChartPainter())),
        const SizedBox(height: 18),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _legendDot('CONTINUOUS HR', const Color(0xFF06B6D4)),
          const SizedBox(width: 20),
          _legendDot('GLUCOSE MONITORING', const Color(0xFFF59E0B)),
        ]),
        const SizedBox(height: 10),
        _legendDot('EHR RECORD', const Color(0xFF5A6A6D)),
      ]),
    );
  }

  Widget _legendDot(String t, Color c) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text(t, style: const TextStyle(color: Color(0xFF5A6A6D), fontSize: 8, fontWeight: FontWeight.w700)),
    ]);
  }
}

// ═══════════════════════════════════════════
// PAINTERS
// ═══════════════════════════════════════════

class _GridDots extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white.withOpacity(0.03);
    for (double x = 0; x < size.width; x += 20)
      for (double y = 0; y < size.height; y += 20)
        canvas.drawCircle(Offset(x, y), 0.5, p);
  }
  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

class _ArcPainter extends CustomPainter {
  final double p;
  _ArcPainter(this.p);
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 4;
    canvas.drawCircle(c, r, Paint()..color = Colors.white.withOpacity(0.06)..style = PaintingStyle.stroke..strokeWidth = 6);
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r), -pi / 2, 2 * pi * p, false,
      Paint()..style = PaintingStyle.stroke..strokeWidth = 6..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          startAngle: -pi / 2, endAngle: 3 * pi / 2,
          colors: const [Color(0xFF0EA5E9), Color(0xFF22D3EE)],
        ).createShader(Rect.fromCircle(center: c, radius: r)),
    );
    final a = -pi / 2 + 2 * pi * p;
    canvas.drawCircle(Offset(c.dx + r * cos(a), c.dy + r * sin(a)), 4, Paint()..color = const Color(0xFF22D3EE));
  }
  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

class _WavePainter extends CustomPainter {
  final Color c;
  _WavePainter(this.c);
  @override
  void paint(Canvas canvas, Size size) {
    final pts = [0.5, 0.35, 0.6, 0.25, 0.7, 0.3, 0.55, 0.4, 0.65, 0.3, 0.5, 0.4, 0.6];
    final path = Path()..moveTo(0, size.height * pts[0]);
    for (int i = 1; i < pts.length; i++)
      path.lineTo(size.width * (i / (pts.length - 1)), size.height * pts[i]);
    canvas.drawPath(path, Paint()..color = c.withOpacity(0.7)..strokeWidth = 1.5..style = PaintingStyle.stroke);
    final fp = Path.from(path)..lineTo(size.width, size.height)..lineTo(0, size.height)..close();
    canvas.drawPath(fp, Paint()..shader = LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [c.withOpacity(0.12), Colors.transparent],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
  }
  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gp = Paint()..color = Colors.white.withOpacity(0.04)..strokeWidth = 1;
    for (int i = 0; i < 4; i++) canvas.drawLine(Offset(size.width * (i / 3), 0), Offset(size.width * (i / 3), size.height), gp);

    // HR line
    final hr = Path()..moveTo(0, size.height * 0.6);
    hr.cubicTo(size.width * 0.12, size.height * 0.4, size.width * 0.25, size.height * 0.5, size.width * 0.4, size.height * 0.3);
    hr.cubicTo(size.width * 0.55, size.height * 0.15, size.width * 0.7, size.height * 0.4, size.width, size.height * 0.25);
    canvas.drawPath(hr, Paint()..color = const Color(0xFF06B6D4)..strokeWidth = 2..style = PaintingStyle.stroke);
    final hrf = Path.from(hr)..lineTo(size.width, size.height)..lineTo(0, size.height)..close();
    canvas.drawPath(hrf, Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [const Color(0xFF06B6D4).withOpacity(0.10), Colors.transparent]).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));

    // Glucose line
    final gl = Path()..moveTo(0, size.height * 0.75);
    gl.cubicTo(size.width * 0.15, size.height * 0.6, size.width * 0.35, size.height * 0.7, size.width * 0.5, size.height * 0.5);
    gl.cubicTo(size.width * 0.65, size.height * 0.35, size.width * 0.8, size.height * 0.55, size.width, size.height * 0.45);
    canvas.drawPath(gl, Paint()..color = const Color(0xFFF59E0B)..strokeWidth = 2..style = PaintingStyle.stroke);
    final glf = Path.from(gl)..lineTo(size.width, size.height)..lineTo(0, size.height)..close();
    canvas.drawPath(glf, Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [const Color(0xFFF59E0B).withOpacity(0.06), Colors.transparent]).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));

    // Markers
    canvas.drawCircle(Offset(size.width * 0.22, size.height * 0.42), 10, Paint()..color = const Color(0xFF06B6D4).withOpacity(0.15));
    canvas.drawCircle(Offset(size.width * 0.22, size.height * 0.42), 5, Paint()..color = const Color(0xFF06B6D4));
    final tri = Path()..moveTo(size.width * 0.72, size.height * 0.38 - 7)..lineTo(size.width * 0.72 - 6, size.height * 0.38 + 5)..lineTo(size.width * 0.72 + 6, size.height * 0.38 + 5)..close();
    canvas.drawPath(tri, Paint()..color = const Color(0xFFF59E0B));
  }
  @override
  bool shouldRepaint(covariant CustomPainter o) => false;
}
